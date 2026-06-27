with items as (
    select * from {{ ref('stg_olist__order_items') }}
),

products as (
    select * from {{ ref('stg_olist__products') }}
),

sellers as (
    select * from {{ ref('stg_olist__sellers') }}
),

category_translations as (
    select * from {{ ref('product_category_name_translation') }}
),

joined as (
    select
        i.order_id,
        i.order_item_id,
        i.product_id,
        i.seller_id,
        i.shipping_limit_date,
        i.item_price,
        i.freight_value,
        i.total_item_value,

        p.category_name as product_category_name_pt,
        coalesce(ct.product_category_name_english, p.category_name) as category_name,

        p.weight_g,

        s.seller_city as seller_city,
        s.seller_state as seller_state
    from items i
    left join products p on i.product_id = p.product_id
    left join sellers s on i.seller_id = s.seller_id
    left join category_translations ct on p.category_name = ct.product_category_name
)

select * from joined