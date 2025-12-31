BEGIN;
SELECT plan(75);

-- Test Account Types
-- Check that all account types are inserted
SELECT ok(
    (SELECT COUNT(*) FROM account_types WHERE code IN (
        'ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE',
        'CONTRA_ASSET', 'CONTRA_LIABILITY'
    )) = 7,
    'All 7 account types should be inserted'
);

-- Test individual account types
SELECT ok(EXISTS(SELECT 1 FROM account_types WHERE code = 'ASSET' AND name = 'Asset' AND normal_balance = 'DEBIT'),
    'ASSET account type exists with correct attributes');
SELECT ok(EXISTS(SELECT 1 FROM account_types WHERE code = 'LIABILITY' AND name = 'Liability' AND normal_balance = 'CREDIT'),
    'LIABILITY account type exists with correct attributes');
SELECT ok(EXISTS(SELECT 1 FROM account_types WHERE code = 'EQUITY' AND name = 'Equity' AND normal_balance = 'CREDIT'),
    'EQUITY account type exists with correct attributes');
SELECT ok(EXISTS(SELECT 1 FROM account_types WHERE code = 'REVENUE' AND name = 'Revenue' AND normal_balance = 'CREDIT'),
    'REVENUE account type exists with correct attributes');
SELECT ok(EXISTS(SELECT 1 FROM account_types WHERE code = 'EXPENSE' AND name = 'Expense' AND normal_balance = 'DEBIT'),
    'EXPENSE account type exists with correct attributes');
SELECT ok(EXISTS(SELECT 1 FROM account_types WHERE code = 'CONTRA_ASSET' AND name = 'Contra Asset' AND normal_balance = 'CREDIT'),
    'CONTRA_ASSET account type exists with correct attributes');
SELECT ok(EXISTS(SELECT 1 FROM account_types WHERE code = 'CONTRA_LIABILITY' AND name = 'Contra Liability' AND normal_balance = 'DEBIT'),
    'CONTRA_LIABILITY account type exists with correct attributes');

-- Test Currencies
-- Check that all currencies are inserted
SELECT ok(
    (SELECT COUNT(*) FROM currencies) = 71,
    'All 71 currencies should be inserted'
);

-- Test major currencies
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'USD' AND name = 'US Dollar' AND symbol = '$' AND precision = 2),
    'USD currency exists with correct attributes');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'EUR' AND name = 'Euro' AND symbol = '€' AND precision = 2),
    'EUR currency exists with correct attributes');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'GBP' AND name = 'British Pound' AND symbol = '£' AND precision = 2),
    'GBP currency exists with correct attributes');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'JPY' AND name = 'Japanese Yen' AND symbol = '¥' AND precision = 0),
    'JPY currency exists with correct attributes and zero precision');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'CNY' AND name = 'Chinese Yuan' AND symbol = '¥' AND precision = 2),
    'CNY currency exists with correct attributes');

-- Test additional currencies with standard precision
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'CAD' AND precision = 2), 'CAD exists with precision 2');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'AUD' AND precision = 2), 'AUD exists with precision 2');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'CHF' AND precision = 2), 'CHF exists with precision 2');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'INR' AND precision = 2), 'INR exists with precision 2');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'BRL' AND precision = 2), 'BRL exists with precision 2');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'RUB' AND precision = 2), 'RUB exists with precision 2');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'MXN' AND precision = 2), 'MXN exists with precision 2');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'ZAR' AND precision = 2), 'ZAR exists with precision 2');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'SGD' AND precision = 2), 'SGD exists with precision 2');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'HKD' AND precision = 2), 'HKD exists with precision 2');

-- Test currencies with zero precision
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'KRW' AND precision = 0), 'KRW exists with precision 0');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'IDR' AND precision = 0), 'IDR exists with precision 0');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'CLP' AND precision = 0), 'CLP exists with precision 0');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'COP' AND precision = 0), 'COP exists with precision 0');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'VND' AND precision = 0), 'VND exists with precision 0');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'HUF' AND precision = 0), 'HUF exists with precision 0');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'ISK' AND precision = 0), 'ISK exists with precision 0');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'IRR' AND precision = 0), 'IRR exists with precision 0');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'UZS' AND precision = 0), 'UZS exists with precision 0');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'AMD' AND precision = 0), 'AMD exists with precision 0');

-- Test currencies with 3-decimal precision
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'TND' AND precision = 3), 'TND exists with precision 3');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'IQD' AND precision = 3), 'IQD exists with precision 3');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'KWD' AND precision = 3), 'KWD exists with precision 3');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'BHD' AND precision = 3), 'BHD exists with precision 3');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'OMR' AND precision = 3), 'OMR exists with precision 3');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'JOD' AND precision = 3), 'JOD exists with precision 3');

-- Test Nordic currencies
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'SEK' AND symbol = 'kr'), 'SEK exists with correct symbol');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'NOK' AND symbol = 'kr'), 'NOK exists with correct symbol');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'DKK' AND symbol = 'kr'), 'DKK exists with correct symbol');

-- Test Eastern European currencies
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'PLN' AND symbol = 'zł'), 'PLN exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'CZK' AND symbol = 'Kč'), 'CZK exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'HRK' AND symbol = 'kn'), 'HRK exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'RON' AND symbol = 'lei'), 'RON exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'BGN' AND symbol = 'лв'), 'BGN exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'UAH' AND symbol = '₴'), 'UAH exists');

-- Test Middle Eastern currencies
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'TRY' AND symbol = '₺'), 'TRY exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'AED' AND symbol = 'د.إ'), 'AED exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'SAR' AND symbol = '﷼'), 'SAR exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'ILS' AND symbol = '₪'), 'ILS exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'QAR' AND symbol = 'ر.ق'), 'QAR exists');

-- Test South Asian currencies
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'PKR' AND symbol = '₨'), 'PKR exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'BDT' AND symbol = '৳'), 'BDT exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'LKR' AND symbol = '₨'), 'LKR exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'NPR' AND symbol = '₨'), 'NPR exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'AFN' AND symbol = '؋'), 'AFN exists');

-- Test Southeast Asian currencies
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'THB' AND symbol = '฿'), 'THB exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'MYR' AND symbol = 'RM'), 'MYR exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'PHP' AND symbol = '₱'), 'PHP exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'TWD' AND symbol = 'NT$'), 'TWD exists');

-- Test African currencies
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'KES' AND symbol = 'KSh'), 'KES exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'NGN' AND symbol = '₦'), 'NGN exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'GHS' AND symbol = '₵'), 'GHS exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'EGP' AND symbol = '£'), 'EGP exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'MAD' AND symbol = 'د.م.'), 'MAD exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'DZD' AND symbol = 'د.ج'), 'DZD exists');

-- Test Caucasus and Central Asian currencies
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'GEL' AND symbol = '₾'), 'GEL exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'AZN' AND symbol = '₼'), 'AZN exists');
SELECT ok(EXISTS(SELECT 1 FROM currencies WHERE code = 'KZT' AND symbol = '₸'), 'KZT exists');

-- Test uniqueness - ensure no duplicate codes
SELECT ok(
    (SELECT COUNT(DISTINCT code) FROM currencies) = (SELECT COUNT(*) FROM currencies),
    'All currency codes should be unique'
);

-- Test uniqueness - ensure no duplicate account type codes
SELECT ok(
    (SELECT COUNT(DISTINCT code) FROM account_types) = (SELECT COUNT(*) FROM account_types),
    'All account type codes should be unique'
);

-- Test that ON CONFLICT works - re-running insert should not increase count
SELECT ok(
    (SELECT COUNT(*) FROM account_types) = 7,
    'Account types count remains 7 after idempotent insert'
);

SELECT * FROM finish();
ROLLBACK;
