with sources as (
    select * from {{ source('olist_raw', 'olist_sellers') }}
),

renamed as (
    select
        seller_id,
        seller_zip_code_prefix as zip_code_prefix,
        initcap(seller_city) as seller_city,
        upper(seller_state) as seller_state
    from sources
)

select * from renamed