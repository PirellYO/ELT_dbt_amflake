{% snapshot orders_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='order_id',
        strategy='check',
        check_cols=['order_status']
    )
}}

select 
    order_id,
    customer_id,
    ordered_at,
    order_status,
    approved_at,
    delivered_to_customer_at,
From {{ ref('stg_olist__orders') }}

{% endsnapshot %}