# Architecture

## Overview

This project implements a **multi-tenant, multi-currency double-entry accounting system** built on PostgreSQL 18. The system provides a robust foundation for ledger management with strict data isolation, automated balance tracking, and comprehensive validation of accounting principles.

## System Components

### Database Layer
- **PostgreSQL 18**: Core relational database with pgcrypto extension for UUID generation
- **pgTap**: Unit testing framework for database logic validation
- **Row-Level Security (RLS)**: Enforces tenant data isolation at the database level

### Migration & Schema Management
- **Atlas**: Database migration tool for versioned schema management
- **Migration Format**: Sequential SQL files in `schema/` directory
- **Version Control**: `atlas.sum` checksum file for migration integrity

### Development Tools
- **Docker Compose**: Orchestrates all services with health checks and dependencies
- **pgAdmin 4**: Web-based database management interface
- **Docker Volumes**: Persistent storage for database and pgAdmin data

## Data Model

### Core Entities

#### Tenants
- Multi-tenant isolation root entity
- Each tenant has isolated chart of accounts and transactions
- UUID-based primary keys for global uniqueness

#### Account Types
- Standard double-entry categories: Asset, Liability, Equity, Revenue, Expense
- Normal balance tracking (DEBIT/CREDIT) for validation
- Shared across all tenants (reference data)

#### Currencies
- Multi-currency support with configurable precision
- ISO currency codes (e.g., USD, EUR)
- Shared across tenants (reference data)

#### Accounts (Chart of Accounts)
- Per-tenant account definitions
- Hierarchical structure with parent-child relationships
- Single currency per account
- Unique account numbers within tenant scope
- Row-level security enforced via `tenant_id`

#### Journal Entries
- Transaction headers with metadata support
- Reference numbers for external document linking
- Tenant-scoped with RLS policies
- JSONB metadata field for flexible tax/country-specific data

#### Journal Entry Lines
- Individual debit/credit line items
- Enforced constraint: each line is either debit OR credit (not both)
- Non-negative amounts only
- Linked to specific accounts

#### Account Balances
- Denormalized balance cache for performance
- Separate debit and credit balance tracking
- Automatically updated via journal entry creation
- One-to-one relationship with accounts

## Architectural Patterns

### Multi-Tenancy
- **Session-based isolation**: `app.current_tenant_id` session variable
- **RLS policies**: Automatic filtering of queries by tenant
- **Default values**: Auto-populate `tenant_id` from session context
- **Cascade policies**: Tenant deletion removes all associated data

### Data Isolation Strategy
```
┌─────────────┐
│   Tenants   │
└──────┬──────┘
       │
       ├──────────────┬──────────────────┐
       │              │                  │
┌──────▼──────┐  ┌───▼──────────┐  ┌────▼────────┐
│  Accounts   │  │   Journal    │  │  Account    │
│             │  │   Entries    │  │  Balances   │
└─────┬───────┘  └──────┬───────┘  └─────────────┘
      │                 │
      └────────┬────────┘
               │
        ┌──────▼──────────┐
        │  Journal Entry  │
        │     Lines       │
        └─────────────────┘
```

### Double-Entry Accounting Validation
1. **Balance Validation**: Total debits must equal total credits per journal entry
2. **Line Constraints**: Each line must have either debit or credit (not both, not neither)
3. **Positive Amounts**: Only non-negative values allowed
4. **Minimum Lines**: Journal entries require at least 2 lines
5. **Account Consistency**: All accounts in an entry must belong to the same tenant

### Transaction Processing Flow
```
1. Validate balanced entry (Σ debits = Σ credits)
2. Validate account ownership (all accounts belong to tenant)
3. Insert journal entry header
4. Insert journal entry lines
5. Update account balances atomically
```

## Key Functions

### `create_tenant(p_name)`
- Creates new tenant entity
- Returns tenant UUID
- Entry point for new organization setup

### `create_account(...)`
- Creates account within current tenant context
- Automatically initializes account balance record
- Supports hierarchical account structure

### `create_journal_entry(...)`
- Validates double-entry accounting rules
- Ensures tenant data isolation
- Updates account balances transactionally
- Accepts JSONB array of line items for flexibility

## Security Architecture

### Row-Level Security Policies
- **Accounts**: Only see accounts where `tenant_id` matches session
- **Journal Entries**: Only see entries where `tenant_id` matches session
- **Journal Entry Lines**: Only see lines for accessible journal entries
- **Account Balances**: Only see balances for accessible accounts

### Session Context Pattern
```sql
-- Application sets tenant context at session start
SET app.current_tenant_id = '<tenant-uuid>';

-- All subsequent queries automatically filtered
SELECT * FROM accounts;  -- Only returns current tenant's accounts
```

## Development Workflow

### Local Development Stack
1. **Start**: `docker compose up`
2. **Migration**: Automatic via `migrate` service on startup
3. **Testing**: `docker compose run --rm pgtap`
4. **UI Access**: pgAdmin at http://localhost:5050

### Migration Management
- **New Migration**: Create `schema/XX_description.sql`
- **Hash Generation**: `docker compose run --rm hash`
- **Apply**: `docker compose run --rm migrate`
- **Rollback**: `docker compose run --rm migrate migrate down -- 1`

### Testing Strategy
- Unit tests in `PGTap/` directory
- Test core schema, functions, and constraints
- Automated execution via pg_prove
- Validates accounting rules and data integrity

## Performance Considerations

### Denormalized Balances
- `account_balances` table caches debit/credit sums
- Updated inline during journal entry creation
- Eliminates need for aggregate queries on large transaction tables

### Indexing Strategy
- Primary keys: UUID with `gen_random_uuid()`
- Unique constraints: `(tenant_id, account_number)` for accounts
- Foreign key indexes: Implicit on relationship columns
- RLS optimization: Tenant ID filters leverage indexes

## Service Dependencies

```
┌─────────────┐
│   pgadmin   │ (manual profile)
└──────┬──────┘
       │
┌──────▼──────┐
│     db      │◄─────────┬─────────┐
│ (postgres)  │          │         │
└──────┬──────┘          │         │
       │                 │         │
       │            ┌────▼────┐  ┌─▼──────┐
       │            │ migrate │  │  hash  │
       │            └─────────┘  └────────┘
       │                            (manual)
       │
  ┌────▼────┐
  │  pgtap  │ (manual profile)
  └─────────┘
```

### Service Health Checks
- **DB**: `pg_isready` probe (5s interval, 15 retries)
- **Migrate**: Depends on DB health, runs once and exits
- **pgAdmin**: Depends on DB health, long-running service

## Configuration

### Environment Variables
- `POSTGRES_USER`, `PGPASSWORD`: Database credentials
- `PGDATABASE`: Database name (default: `ledger`)
- `PGPORT`: PostgreSQL port (default: 5432)
- `PGHOST`: Database hostname (default: `db`)
- `PGADMIN_*`: pgAdmin credentials and port

### Docker Profiles
- **Default**: db + migrate (minimal production-like setup)
- **Manual**: pgadmin, hash, pgtap (opt-in developer tools)

## Design Principles

1. **Tenant Isolation**: Database-level enforcement via RLS
2. **Audit Trail**: Immutable journal entries with timestamps
3. **Data Integrity**: Constraints enforce accounting rules
4. **Performance**: Denormalized balances + indexed queries
5. **Flexibility**: JSONB metadata for country-specific requirements
6. **Testability**: Comprehensive pgTap test coverage
7. **Maintainability**: Version-controlled migrations with checksums

## Future Extensibility

- **Audit Logging**: Add trigger-based change tracking
- **Soft Deletes**: Implement `deleted_at` columns for historical queries
- **Currency Conversion**: Add exchange rate tables and conversion functions
- **Reporting**: Materialized views for trial balance, P&L, balance sheet
- **API Layer**: REST/GraphQL service with connection pooling
- **Multi-Period**: Fiscal period close process and historical snapshots
