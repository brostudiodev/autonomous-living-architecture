-- ============================================
-- Enhanced Transaction Categorization Function
-- Complements existing get_category_names_from_description()
-- ============================================

CREATE OR REPLACE FUNCTION public.enhanced_transaction_categorization(
    description_input TEXT,
    amount_input NUMERIC,
    merchant_name_input TEXT DEFAULT NULL,
    account_name_input TEXT DEFAULT NULL
) 
RETURNS TABLE(
    category_name VARCHAR(100),
    subcategory_name VARCHAR(100),
    confidence_score NUMERIC,
    categorization_method TEXT,
    reasoning TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_merchant_id INTEGER;
    v_default_category_id INTEGER;
    v_category_name VARCHAR(100);
    v_subcategory_name VARCHAR(100);
    v_confidence NUMERIC := 0.0;
    v_method TEXT := 'enhanced_rules';
    v_reasoning TEXT := 'Initial processing';
BEGIN
    -- ============================================
    -- STEP 1: Merchant-Based Categorization (Highest Confidence)
    -- ============================================
    IF merchant_name_input IS NOT NULL THEN
        SELECT merchant_id, default_category_id 
        INTO v_merchant_id, v_default_category_id
        FROM merchants 
        WHERE LOWER(merchant_name) = LOWER(merchant_name_input);
        
        IF v_merchant_id IS NOT NULL THEN
            SELECT category_name, subcategory_name 
            INTO v_category_name, v_subcategory_name
            FROM categories 
            WHERE category_id = v_default_category_id;
            
            v_confidence := 0.95;
            v_method := 'merchant_based';
            v_reasoning := 'Found exact merchant match: ' || merchant_name_input;
        END IF;
    END IF;
    
    -- ============================================
    -- STEP 2: Description-Based Rules (High Confidence)
    -- ============================================
    IF v_category_name IS NULL THEN
        -- Supermarket/Grocery Patterns
        IF LOWER(description_input) ~ ANY(ARRAY[
            'supermarket', 'tesco', 'lidl', ' biedronka', 'auchan', 'kaufland', 
            'carrefour', ' Lewiatan', 'stokrotka', 'polomarket', 'netto',
            'grocery', 'food', 'market', 'delikatesy', 'żabka'
        ]) THEN
            v_category_name := 'Lifestyle';
            v_subcategory_name := 'Groceries';
            v_confidence := 0.85;
            v_reasoning := 'Detected supermarket/grocery pattern in description';
        END IF;
        
        -- Restaurant/Food Patterns
        IF LOWER(description_input) ~ ANY(ARRAY[
            'restaurant', 'bar', 'caffe', 'coffee', 'pizza', 'burger', 
            'kebab', 'sushi', 'bistro', 'pub', 'grill', 'diner'
        ]) THEN
            v_category_name := 'Lifestyle';
            v_subcategory_name := 'Restaurants';
            v_confidence := 0.85;
            v_reasoning := 'Detected restaurant/food service pattern';
        END IF;
        
        -- Transport/Fuel Patterns
        IF LOWER(description_input) ~ ANY(ARRAY[
            'bp', 'shell', 'orlen', 'pkn orlen', 'circle k', 'e-petrol',
            'fuel', 'petrol', 'diesel', 'gas station', 'parking',
            'taxi', 'uber', 'bolt', 'parking'
        ]) THEN
            v_category_name := 'Transportation';
            v_subcategory_name := 'Fuel';
            v_confidence := 0.90;
            v_reasoning := 'Detected fuel/transport pattern';
        END IF;
        
        -- Utilities Patterns
        IF LOWER(description_input) ~ ANY(ARRAY[
            'energa', 'pge', 'tauron', 'enea', 'innogy', 'gas',
            'water', 'electricity', 'heating', 'internet', 'telekom',
            'orange', 'play', 'plus', 't-mobile'
        ]) THEN
            v_category_name := 'Housing';
            v_subcategory_name := 'Utilities';
            v_confidence := 0.90;
            v_reasoning := 'Detected utility provider pattern';
        END IF;
        
        -- Banking/Financial Patterns
        IF LOWER(description_input) ~ ANY(ARRAY[
            'bank fee', 'commission', 'interest', 'loan', 'credit',
            'insurance', 'tax', 'government', 'zUS', 'urząd'
        ]) THEN
            v_category_name := 'Financial';
            v_subcategory_name := 'Fees & Taxes';
            v_confidence := 0.85;
            v_reasoning := 'Detected financial institution pattern';
        END IF;
        
        -- Entertainment Patterns
        IF LOWER(description_input) ~ ANY(ARRAY[
            'cinema', 'theater', 'theatre', 'concert', 'netflix', 'spotify',
            'hbo', 'disney', 'amazon prime', 'game', 'steam'
        ]) THEN
            v_category_name := 'Lifestyle';
            v_subcategory_name := 'Entertainment';
            v_confidence := 0.80;
            v_reasoning := 'Detected entertainment/streaming pattern';
        END IF;
        
        -- Health/Medical Patterns
        IF LOWER(description_input) ~ ANY(ARRAY[
            'pharmacy', 'apteka', 'doctor', 'medical', 'hospital',
            'clinic', 'dentist', 'stomatolog', 'lekarz'
        ]) THEN
            v_category_name := 'Healthcare';
            v_subcategory_name := 'Medical';
            v_confidence := 0.85;
            v_reasoning := 'Detected healthcare/pharmacy pattern';
        END IF;
    END IF;
    
    -- ============================================
    -- STEP 3: Amount-Based Heuristics (Medium Confidence)
    -- ============================================
    IF v_category_name IS NULL THEN
        -- Small recurring charges (subscriptions)
        IF amount_input BETWEEN 10 AND 100 AND amount_input % 1 = 0 THEN
            v_category_name := 'Lifestyle';
            v_subcategory_name := 'Subscriptions';
            v_confidence := 0.60;
            v_method := 'amount_based';
            v_reasoning := 'Likely subscription based on amount and round number';
        END IF;
        
        -- Large expenses (potentially one-time purchases)
        IF amount_input > 500 THEN
            v_category_name := 'Lifestyle';
            v_subcategory_name := 'Major Purchases';
            v_confidence := 0.50;
            v_method := 'amount_based';
            v_reasoning := 'Large amount suggests major purchase';
        END IF;
    END IF;
    
    -- ============================================
    -- STEP 4: Income Detection (High Priority)
    -- ============================================
    IF LOWER(description_input) ~ ANY(ARRAY[
        'salary', 'wage', 'payroll', 'income', 'przelew', 'transfer',
        'zUS', 'zus', 'government', 'benefit', 'refund', 'return'
    ]) AND amount_input > 1000 THEN
        v_category_name := 'Income';
        v_subcategory_name := 'Salary';
        v_confidence := 0.90;
        v_method := 'income_detection';
        v_reasoning := 'Detected income pattern with large amount';
    END IF;
    
    -- ============================================
    -- STEP 5: Default Categorization (Lowest Confidence)
    -- ============================================
    IF v_category_name IS NULL THEN
        v_category_name := 'Lifestyle';
        v_subcategory_name := 'Other';
        v_confidence := 0.30;
        v_method := 'default';
        v_reasoning := 'No specific pattern found, using default categorization';
    END IF;
    
    -- ============================================
    -- RETURN RESULTS
    -- ============================================
    RETURN QUERY SELECT 
        v_category_name,
        v_subcategory_name,
        v_confidence,
        v_method,
        v_reasoning;
END;
$$;

-- ============================================
-- Auto-Categorization Helper for Bulk Processing
-- ============================================

CREATE OR REPLACE FUNCTION public.auto_categorize_uncategorized_transactions(
    days_back INTEGER DEFAULT 7
)
RETURNS TABLE(
    transactions_processed INTEGER,
    merchants_auto_created INTEGER,
    high_confidence_categorizations INTEGER,
    medium_confidence_categorizations INTEGER,
    low_confidence_categorizations INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_processed INTEGER := 0;
    v_merchants_created INTEGER := 0;
    v_high_conf INTEGER := 0;
    v_med_conf INTEGER := 0;
    v_low_conf INTEGER := 0;
    rec RECORD;
BEGIN
    -- Process all uncategorized transactions from last N days
    FOR rec IN 
        SELECT 
            transaction_id,
            transaction_date,
            description,
            amount,
            merchant_source,
            account_id
        FROM transactions 
        WHERE category_id IS NULL 
          AND transaction_date >= CURRENT_DATE - INTERVAL '1 day' * days_back
    LOOP
        -- Get enhanced categorization
        SELECT 
            category_name,
            subcategory_name,
            confidence_score
        INTO rec.category_name, rec.subcategory_name, rec.confidence_score
        FROM enhanced_transaction_categorization(
            rec.description,
            rec.amount,
            rec.merchant_source
        ) LIMIT 1;
        
        -- Get category_id
        SELECT category_id INTO rec.category_id
        FROM categories 
        WHERE category_name = rec.category_name 
          AND subcategory_name = rec.subcategory_name;
        
        -- Auto-create merchant if not exists and confidence is high
        IF rec.confidence_score >= 0.80 THEN
            INSERT INTO merchants (merchant_name, default_category_id, data_type)
            VALUES (rec.merchant_source, rec.category_id, 'atomic')
            ON CONFLICT (merchant_name) DO NOTHING;
            
            GET DIAGNOSTICS v_merchants_created = ROW_COUNT;
        END IF;
        
        -- Update transaction categorization
        UPDATE transactions 
        SET 
            category_id = rec.category_id,
            updated_at = CURRENT_TIMESTAMP
        WHERE transaction_id = rec.transaction_id 
          AND transaction_date = rec.transaction_date;
        
        v_processed := v_processed + 1;
        
        -- Count confidence levels
        IF rec.confidence_score >= 0.80 THEN
            v_high_conf := v_high_conf + 1;
        ELSIF rec.confidence_score >= 0.60 THEN
            v_med_conf := v_med_conf + 1;
        ELSE
            v_low_conf := v_low_conf + 1;
        END IF;
    END LOOP;
    
    RETURN QUERY SELECT 
        v_processed,
        v_merchants_created,
        v_high_conf,
        v_med_conf,
        v_low_conf;
END;
$$;

-- ============================================
-- Create Index for Performance
-- ============================================

CREATE INDEX IF NOT EXISTS idx_transactions_uncategorized 
ON transactions (transaction_date) 
WHERE category_id IS NULL;

-- ============================================
-- Add Comments for Documentation
-- ============================================

COMMENT ON FUNCTION public.enhanced_transaction_categorization(TEXT, NUMERIC, TEXT, TEXT) IS 
'Enhanced transaction categorization using merchant lookup, pattern matching, and amount heuristics. Returns category, subcategory, confidence score (0-1), method used, and reasoning.';

COMMENT ON FUNCTION public.auto_categorize_uncategorized_transactions(INTEGER) IS 
'Bulk processing function that automatically categorizes all uncategorized transactions from the last N days. Returns processing statistics including confidence level breakdown.';