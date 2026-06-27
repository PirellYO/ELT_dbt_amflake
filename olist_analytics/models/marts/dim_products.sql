with products as (
    select * from {{ ref('stg_olist__products') }}
),

category_translations as (
    select * from {{ ref('product_category_name_translation') }}
),

item_stats as (
    select
        product_id,
        count(distinct order_id) as nb_orders,
        count(*) as nb_times_sold,
        sum(item_price) as total_revenue,
        avg(item_price) as avg_price,
    from {{ ref('int_order_items_joined') }}
    group by 1
),

final as (
    select
        p.product_id,
        coalesce(ct.category_name_english, p.category_name_pt, 'Unknown') as category_name,
        p.category_name_pt,
        p.weight_g,
        p.length_cm,
        p.height_cm,
        p.width_cm,
        p.nb_times_sold,
        s.avg_price,
        s.total_revenue,

    from products p
    left join category_translations ct on p.category_name_pt = ct.category_name
    left join item_stats s on p.product_id = s.product_id
)

select * from final