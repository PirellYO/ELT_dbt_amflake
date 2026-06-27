with orders as (
    select * from {{ ref('int_orders_enriched') }}
),

final as (
    select
        o.order_id,
        o.customer_unique_id,
        o.ordered_at,
        o.order_status,
        o.payment_type as payment_type,
        o.customer_state,
        o.total_paid,
        o.max_installments,
        o.delivery_days,
        o.delivery_vs_estimate_days,
        o.review_score,

        CASE 
            WHEN o.delivery_vs_estimate_days  <= 0 THEN true else false end as is_delivered_on_time,
        CASE
            WHEN o.order_status = 'delivered' THEN true else false end as is_delivered
    from orders o
)

select * from final