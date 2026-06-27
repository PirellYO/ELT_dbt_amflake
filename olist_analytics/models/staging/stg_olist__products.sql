with sources as (
    select * from {{ source('olist_raw', 'olist_products') }}
),

renamed as (
    select
        product_id,
        product_category_name as category_name,
        product_weight_g as weight_g,
        product_length_cm as length_cm,
        product_height_cm as height_cm,
        product_width_cm as width_cm,
        product_photos_qty as nb_photos
    from sources
)

select * from renamed