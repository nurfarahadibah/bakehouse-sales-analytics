-- Silver: Clean transactions with data quality
CREATE OR REFRESH MATERIALIZED VIEW _silver_bakehouse.transactions
COMMENT "Cleaned and validated transactions"
AS SELECT DISTINCT
    transactionID,
    customerID,
    franchiseID,
    dateTime,
    DATE(dateTime) AS sale_date,
    YEAR(dateTime) AS sale_year,
    MONTH(dateTime) AS sale_month,
    DAY(dateTime) AS sale_day,
    QUARTER(dateTime) AS sale_quarter,
    DAYOFWEEK(dateTime) AS day_of_week,
    product,
    quantity,
    unitPrice,
    totalPrice,
    paymentMethod,
    cardNumber
FROM _bronze_bakehouse.transactions
WHERE transactionID IS NOT NULL
  AND quantity > 0
  AND unitPrice > 0
  AND totalPrice > 0
  AND dateTime IS NOT NULL;

-- Silver: Clean customers
CREATE OR REFRESH MATERIALIZED VIEW _silver_bakehouse.customers
COMMENT "Cleaned customer data"
AS SELECT DISTINCT
    customerID,
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name,
    email_address,
    phone_number,
    address,
    city,
    state,
    country,
    continent,
    postal_zip_code,
    gender
FROM _bronze_bakehouse.customers
WHERE customerID IS NOT NULL
  AND email_address LIKE '%@%';

-- Silver: Clean franchises
CREATE OR REFRESH MATERIALIZED VIEW _silver_bakehouse.franchises
COMMENT "Cleaned franchise data"
AS SELECT DISTINCT
    franchiseID,
    name,
    city,
    district,
    zipcode,
    country,
    size,
    longitude,
    latitude,
    supplierID
FROM _bronze_bakehouse.franchises
WHERE franchiseID IS NOT NULL;

-- Silver: Clean suppliers (approved only)
CREATE OR REFRESH MATERIALIZED VIEW _silver_bakehouse.suppliers
COMMENT "Approved suppliers only"
AS SELECT DISTINCT
    supplierID,
    name,
    ingredient,
    continent,
    city,
    district,
    size,
    longitude,
    latitude
FROM _bronze_bakehouse.suppliers
WHERE supplierID IS NOT NULL
  AND approved = true;