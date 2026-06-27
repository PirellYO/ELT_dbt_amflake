-- Use admin account for creation the infrastructure
USE ROLE ACCOUNTADMIN;

CREATE WAREHOUSE IF NOT EXISTS TRANSFORM_WH
    WITH WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;


-- Create a dedicated role to DBT
CREATE ROLE IF NOT EXISTS TRANSFORM;
GRANT ROLE TRANSFORM TO ROLE SYSADMIN;
GRANT USAGE ON WAREHOUSE TRANSFORM_WH TO ROLE TRANSFORM;
GRANT OPERATE ON WAREHOUSE TRANSFORM_WH TO ROLE TRANSFORM;

-- Creation of the Database
CREATE DATABASE IF NOT EXISTS OLIST;
GRANT ALL ON DATABASE OLIST TO ROLE TRANSFORM;

-- Grant role to database
GRANT ROLE TRANSFORM TO USER PIRELLYON;

-- Workspace
USE ROLE TRANSFORM;
USE WAREHOUSE TRANSFORM_WH;
USE DATABASE OLIST;


-- Creation of Schema
CREATE SCHEMA IF NOT EXISTS RAW;
USE SCHEMA RAW;

-- Create table
CREATE OR REPLACE TABLE RAW.OLIST_ORDERS (
    order_id VARCHAR,
    customer_id VARCHAR,
    order_status VARCHAR,
    order_purchase_timestamp VARCHAR,
    order_approved_at VARCHAR,
    order_delivered_carrier_date VARCHAR,
    order_delivered_customer_date VARCHAR,
    order_estimated_delivery_date VARCHAR
);

--DROP TABLE OLIST_ORDERS

CREATE OR REPLACE TABLE RAW.OLIST_SELLERS(
    seller_id VARCHAR,
    seller_zip_code_prefix VARCHAR,
    seller_city VARCHAR,
    seller_state VARCHAR
);

CREATE OR REPLACE TABLE RAW.OLIST_PRODUCTS(
    product_id VARCHAR,
    product_category_name VARCHAR,
    product_name_lenght NUMBER,
    product_description_lengh NUMBER,
    product_photos_qty NUMBER,
    product_weight_g NUMBER,
    product_length_cm NUMBER,
    product_height_cm NUMBER,
    product_width_cm NUMBER
);

CREATE OR REPLACE TABLE RAW.OLIST_ORDER_PAYMENTS(
    order_id VARCHAR,
    payment_sequential NUMBER,
    payment_type VARCHAR,
    payment_installments NUMBER,
    payment_value FLOAT
);

CREATE OR REPLACE TABLE RAW.OLIST_ORDER_ITEMS(
    order_id VARCHAR,
    order_item_id NUMBER,
    product_id VARCHAR,
    seller_id VARCHAR,
    shipping_limit_date VARCHAR,
    price FLOAT,
    freight_value FLOAT
);

CREATE OR REPLACE TABLE RAW.OLIST_GEOLOCATION(
    geolocation_zip_code_prefix VARCHAR,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR,
    geolocation_state VARCHAR
);

CREATE OR REPLACE TABLE RAW.OLIST_CUSTOMERS(
    customer_id VARCHAR,
    customer_unique_id VARCHAR,
    customer_zip_code_prefix VARCHAR,
    customer_city VARCHAR,
    customer_state VARCHAR
);

CREATE OR REPLACE TABLE RAW.OLIST_ORDERS_REVIEWS(
    review_id VARCHAR,
    order_id VARCHAR,
    review_score NUMBER,
    review_comment_title VARCHAR,
    review_comment_message VARCHAR,
    review_creation_date VARCHAR,
    review_answer_timestamp VARCHAR
);

--CREATE OR REPLACE TABLE RAW.OLIST()

-- Specify the file format
CREATE OR REPLACE FILE FORMAT RAW.CSV_FORMAT
    Type = 'CSV'
    FIELD_DELIMITER=','
    SKIP_HEADER = 1
    NULL_IF = ('NULL', 'null')
    EMPTY_FIELD_AS_NULL = TRUE
    ENCODING = 'UTF8';


CREATE OR REPLACE STAGE RAW.OLIST_S3_STAGE
    URL = 's3://amzn-pirel-s3-bucket'
    FILE_FORMAT = RAW.CSV_FORMAT
    CREDENTIALS = (
        AWS_KEY_ID = ${AWS_KEY_ID}
        AWS_SECRET_KEY = ${AWS_SECRET_KEY}
    )

LIST @RAW.OLIST_S3_STAGEOLIST.DEV