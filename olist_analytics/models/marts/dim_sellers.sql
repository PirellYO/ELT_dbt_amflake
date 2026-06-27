with sellers as (
    select * from {{ ref('stg_olist__sellers') }}
),


seller_stats as (
    select
        seller_id,
        count(distinct order_id) as nb_orders,
        sum(item_price) as total_revenue,
        avg(freight_value) as avg_freight,
    from {{ ref('int_order_items_joined') }}
    group by 1
),

final as (
    select
        s.seller_id,
        s.seller_city,
        s.seller_state,
        ss.nb_orders,
        ss.total_revenue,
        ss.avg_freight
    from sellers s
    left join seller_stats ss on s.seller_id = ss.seller_id
)

select * from final
