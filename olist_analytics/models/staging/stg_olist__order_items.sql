with sources as (
    select * from {{ source('olist_raw', 'olist_order_items') }}
),

renamed as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        try_to_timestamp_ntz(shipping_limit_date) as shipping_limit_date,
        price as item_price,
        freight_value,
        (price + freight_value) as total_item_value
    from sources
)

select * from renamed