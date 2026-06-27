{{
config(
    materialized='incremental',
    unique_key='order_item_pk',
    on_schema_change='append_new_columns'
)
}}

with items as (
    select * from {{ ref('int_order_items_joined') }}
),
orders as (
    select order_id, ordered_at, customer_unique_id, order_status from {{ ref('int_orders_enriched') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['i.order_id', 'i.order_item_id']) }} as order_item_pk,
        i.order_id,
        i.order_item_id,
        i.category_name,
        i.seller_state,
        i.freight_value,
        i.weight_g,
        o.customer_unique_id,
        i.product_id,
        i.seller_id,
        i.item_price,
        o.ordered_at,
        o.order_status,
        i.total_item_value
    from items i
    left join orders o on i.order_id = o.order_id
)

select * from final


{% if is_incremental() %}

    where ordered_at > (select max(ordered_at) from {{ this }})

{% endif %}