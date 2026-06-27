with orders as (
    select * from {{ ref('stg_olist__orders') }}
),
customers as (
    select * from {{ ref('stg_olist__customers') }}
),

payments as (
    select * from {{ ref('int_payments_aggregated') }}
),
reviews as (
    select order_id, max(review_score) as maxreview_score from {{ ref('stg_olist__order_reviews') }} group by 1
),


enriched as (
    select
        o.order_id,
        o.customer_id,
        
        o.order_status,
        o.ordered_at,
        o.approved_at,
        o.delivered_carrier_date,
        o.delivered_to_customer_at,
        o.estimated_delivery_at,

        datediff('day', o.ordered_at, o.delivered_to_customer_at) as delivery_days,
        datediff('day', o.ordered_at, o.approved_at) as approval_days,
        datediff('day', o.ordered_at, o.estimated_delivery_at) as estimated_days,
        datediff('day', o.estimated_delivery_at, o.delivered_to_customer_at) as delay_days,

        c.customer_unique_id,
        c.customer_city as customer_city,
        c.customer_state as customer_state,


        p.total_paid,
        p.max_installments,
        p.payment_type_sample as payment_type,

        r.max_review_score

    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join payments p on o.order_id = p.order_id
    left join reviews r on o.order_id = r.order_id
)

select * from enriched