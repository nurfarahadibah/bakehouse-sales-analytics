-- ========================================
-- DIMENSION TABLES
-- ========================================

-- Dimension: Customer
CREATE OR REFRESH MATERIALIZED VIEW _gold_bakehouse.dim_customer
COMMENT "Customer dimension with demographics"
AS SELECT
    customerID AS customer_key,
    customerID,
    full_name,
    first_name,
    last_name,
    email_address,
    phone_number,
    address,
    city,
    state,
    country,
    continent,
    postal_zip_code,
    gender
FROM _silver_bakehouse.customers;

-- Dimension: Franchise
CREATE OR REFRESH MATERIALIZED VIEW _gold_bakehouse.dim_franchise
COMMENT "Franchise dimension with location"
AS SELECT
    franchiseID AS franchise_key,
    franchiseID,
    name AS franchise_name,
    city,
    district,
    zipcode,
    country,
    size,
    longitude,
    latitude,
    supplierID
FROM _silver_bakehouse.franchises;

-- Dimension: Supplier
CREATE OR REFRESH MATERIALIZED VIEW _gold_bakehouse.dim_supplier
COMMENT "Supplier dimension"
AS SELECT
    supplierID AS supplier_key,
    supplierID,
    name AS supplier_name,
    ingredient,
    continent,
    city,
    district,
    size,
    longitude,
    latitude
FROM _silver_bakehouse.suppliers;

-- Dimension: Product (derived from transactions)
CREATE OR REFRESH MATERIALIZED VIEW _gold_bakehouse.dim_product
COMMENT "Product dimension"
AS SELECT
    ROW_NUMBER() OVER (ORDER BY product) AS product_key,
    product,
    product AS product_name
FROM (
    SELECT DISTINCT product
    FROM _silver_bakehouse.transactions
);

-- Dimension: Date calendar
CREATE OR REFRESH MATERIALIZED VIEW _gold_bakehouse.dim_date
COMMENT "Date dimension with calendar attributes"
AS SELECT
    CAST(DATE_FORMAT(sale_date, 'yyyyMMdd') AS INT) AS date_key,
    sale_date,
    YEAR(sale_date) AS year,
    QUARTER(sale_date) AS quarter,
    MONTH(sale_date) AS month,
    DATE_FORMAT(sale_date, 'MMMM') AS month_name,
    DAY(sale_date) AS day,
    DAYOFWEEK(sale_date) AS day_of_week,
    DATE_FORMAT(sale_date, 'EEEE') AS day_name,
    WEEKOFYEAR(sale_date) AS week_of_year
FROM (
    SELECT DISTINCT sale_date
    FROM _silver_bakehouse.transactions
);

-- ========================================
-- FACT TABLE
-- ========================================

-- Fact: Sales transactions
CREATE OR REFRESH MATERIALIZED VIEW _gold_bakehouse.fact_sales
COMMENT "Sales fact table with foreign keys to all dimensions"
AS SELECT
    -- Foreign Keys
    t.customerID AS customer_key,
    t.franchiseID AS franchise_key,
    f.supplierID AS supplier_key,
    CAST(DATE_FORMAT(t.sale_date, 'yyyyMMdd') AS INT) AS date_key,
    p.product_key,
    
    -- Degenerate Dimensions
    t.transactionID,
    t.paymentMethod,
    t.cardNumber,
    
    -- Measures
    t.quantity,
    t.unitPrice,
    t.totalPrice,
    
    -- Additional attributes
    t.dateTime AS transaction_datetime,
    t.sale_date
FROM _silver_bakehouse.transactions t
LEFT JOIN _silver_bakehouse.franchises f 
    ON t.franchiseID = f.franchiseID
LEFT JOIN _gold_bakehouse.dim_product p 
    ON t.product = p.product;