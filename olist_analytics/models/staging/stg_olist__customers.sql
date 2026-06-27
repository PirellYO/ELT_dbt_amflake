with sources as (
    select * from {{ source('olist_raw', 'olist_customers') }}
),

renamed as (
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix as zip_code_prefix,
        initcap(customer_city) as customer_city,
        upper(customer_state) as customer_state
    from sources
)

select * from renamed