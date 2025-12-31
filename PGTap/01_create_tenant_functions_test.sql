BEGIN;
SELECT plan(4);

-- Check if function exists
SELECT has_function('create_tenant', ARRAY['character varying', 'uuid']);

-- Test creating a tenant
SELECT is(
    (SELECT count(*) FROM tenants WHERE name = 'Test Tenant'),
    0::bigint,
    'Tenant should not exist before creation'
);

SELECT lives_ok(
    $$ SELECT create_tenant('Test Tenant') $$,
    'create_tenant should execute successfully'
);

-- Verify tenant was created
SELECT is(
    (SELECT count(*) FROM tenants WHERE name = 'Test Tenant'),
    1::bigint,
    'Tenant should exist after creation'
);

SELECT * FROM finish();
ROLLBACK;
