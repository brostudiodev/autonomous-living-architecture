-- Function: upsert_expense_from_sheet
-- Upserts upcoming expense from Google Sheet Expense Calendar
-- Matches by transaction_id (unique), updates all other fields

CREATE OR REPLACE FUNCTION public.upsert_expense_from_sheet(
    _month INTEGER,
    _day INTEGER,
    _name VARCHAR,
    _amount NUMERIC,
    _frequency VARCHAR,
    _description TEXT,
    _transaction_id VARCHAR,
    _expense_date DATE,
    _currency VARCHAR DEFAULT 'PLN',
    _category VARCHAR DEFAULT 'UNCATEGORIZED',
    _sub_category VARCHAR DEFAULT 'UNCATEGORIZED'
) RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
    v_result JSON;
BEGIN
    -- Validate month/day
    IF _month < 1 OR _month > 12 OR _day < 1 OR _day > 31 THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Invalid date: month=' || _month || ', day=' || _day,
            'transaction_id', _transaction_id
        );
    END IF;

    -- Upsert expense
    INSERT INTO upcoming_expenses (
        transaction_id,
        expense_date,
        name,
        amount,
        currency,
        frequency,
        description,
        category,
        sub_category,
        source
    ) VALUES (
        _transaction_id,
        _expense_date,
        _name,
        _amount,
        _currency,
        _frequency,
        _description,
        _category,
        _sub_category,
        'google_sheets'
    )
    ON CONFLICT (transaction_id) 
    DO UPDATE SET
        expense_date = EXCLUDED.expense_date,
        name = EXCLUDED.name,
        amount = EXCLUDED.amount,
        currency = EXCLUDED.currency,
        frequency = EXCLUDED.frequency,
        description = EXCLUDED.description,
        category = EXCLUDED.category,
        sub_category = EXCLUDED.sub_category,
        updated_at = CURRENT_TIMESTAMP;

    RETURN json_build_object(
        'success', true,
        'transaction_id', _transaction_id,
        'action', 'upserted',
        'amount', _amount
    );

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM,
        'transaction_id', _transaction_id
    );
END;
$$;

-- Grant execute to finance_user
GRANT EXECUTE ON FUNCTION upsert_expense_from_sheet TO finance_user;
