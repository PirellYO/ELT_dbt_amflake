with sources as (
    select * from {{ source('olist_raw', 'olist_order_payments') }}
),

renamed as (
    select
        order_id,
        payment_sequential,
        lower(payment_type) as payment_type,
        payment_installments as nb_installments,
        payment_value
    from sources
)

select *
from renamed