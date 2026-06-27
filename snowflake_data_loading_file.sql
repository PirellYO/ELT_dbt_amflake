-- Loop to load all Olist dataset CSV files into corresponding RAW tables
-- Co-authored with CoCo

USE ROLE TRANSFORM;
USE WAREHOUSE TRANSFORM_WH;
USE DATABASE OLIST;

USE SCHEMA RAW;

-- Initial copy command for OLIST_ORDERS table (commented out)

/*
COPY INTO RAW.OLIST_ORDERS
    FROM @RAW.OLIST_S3_STAGE/olist_orders_dataset.csv
    FILE_FORMAT = (FORMAT_NAME = RAW.CSV_FORMAT) 
    ON_ERROR = 'CONTINUE';
*/

BEGIN
    LET tables ARRAY := ARRAY_CONSTRUCT(
        'olist_orders',
        'olist_customers',
        'olist_products',
        'olist_sellers',
        'olist_order_items',
        'olist_order_payments',
        'olist_order_reviews',
        'olist_geolocation'
    );

    LET i INTEGER := 0;
    LET total INTEGER := ARRAY_SIZE(:tables);

    WHILE (:i < :total) DO
        LET table_name VARCHAR := :tables[:i];
        LET file_name VARCHAR := :table_name || '_dataset.csv';

        EXECUTE IMMEDIATE
            'COPY INTO RAW.' || :table_name ||
            ' FROM @RAW.OLIST_S3_STAGE/' || :file_name ||
            ' FILE_FORMAT = (FORMAT_NAME = RAW.CSV_FORMAT)' ||
            ' ON_ERROR = ''CONTINUE''';

        i := :i + 1;
    END WHILE;
END;

SELECT * FROM OLIST_ORDERS LIMIT 10

SELECT CURRENT_ORGANIZATION_NAME() AS ORG,
        CURRENT_ACCOUNT_NAME() AS ACCOUNT,
        CURRENT_REGION() AS REGION,
        CURRENT_USER_NAME as Me;

USE SCHEMA DEV_STAGING;

SELECT * FROM STG_OLIST__ORDERS LIMIT 20;