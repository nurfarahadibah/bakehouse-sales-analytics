-- Bronze: Raw transactions
CREATE OR REFRESH MATERIALIZED VIEW _bronze_bakehouse.transactions
COMMENT "Raw transaction data from samples.bakehouse"
AS SELECT * FROM samples.bakehouse.sales_transactions;

-- Bronze: Raw customers
CREATE OR REFRESH MATERIALIZED VIEW _bronze_bakehouse.customers
COMMENT "Raw customer data from samples.bakehouse"
AS SELECT * FROM samples.bakehouse.sales_customers;

-- Bronze: Raw franchises
CREATE OR REFRESH MATERIALIZED VIEW _bronze_bakehouse.franchises
COMMENT "Raw franchise data from samples.bakehouse"
AS SELECT * FROM samples.bakehouse.sales_franchises;

-- Bronze: Raw suppliers
CREATE OR REFRESH MATERIALIZED VIEW _bronze_bakehouse.suppliers
COMMENT "Raw supplier data from samples.bakehouse"
AS SELECT * FROM samples.bakehouse.sales_suppliers;