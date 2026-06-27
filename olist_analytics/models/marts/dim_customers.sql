with customers as (
    select * from {{ ref('stg_olist__customers') }}
),

orders as (
    select * from {{ ref('int_orders_enriched') }}
),

customers_orders as (
    select
        customer_unique_id,
        count(distinct o.order_id) as nb_orders,
        sum(o.total_paid) as lifetime_value,
        min(o.ordered_at) as first_order_date,
        max(o.ordered_at) as last_order_date,
        avg(review_score) as avg_review_score
    from orders o
    group by 1
),

final as (
    select 
        c.customer_unique_id,
        max(c.customer_city) as customer_city,
        max(c.customer_state) as customer_state,

        coalesce(co.nb_orders, 0) as nb_orders,
        co.lifetime_value,
        co.first_order_date,
        co.last_order_date,
        co.avg_review_score,
        CASE 
            WHEN co.nb_orders > 3 THEN 'loyal'
            WHEN co.nb_orders = 2 THEN 'repeat'
            ELSE 'one-time'
        END as customer_segment

    from customers c
    left join customers_orders co on c.customer_unique_id = co.customer_unique_id
    group by c.customer_unique_id, co.nb_orders, co.lifetime_value, co.first_order_date, co.last_order_date, co.avg_review_score
)

select * from final