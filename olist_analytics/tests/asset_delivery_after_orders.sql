-- an order can't be delivered before it is approved, so we can use this to calculate the number of days it took for the order to be approved

select 
    order_id,
    ordered_at,
    delivered_to_customer_at,
from {{ ref('fct_orders') }}
where delivered_to_customer_at < approved_at