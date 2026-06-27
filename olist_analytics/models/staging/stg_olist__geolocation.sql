with sources as (
    select * from {{ source('olist_raw', 'olist_geolocation') }}
),

renamed as (
    select
        geolocation_zip_code_prefix as zip_code_prefix,
        avg(geolocation_lat) as latitude,
        avg(geolocation_lng) as longitude,
        max(initcap(geolocation_city)) as city,
        max(upper(geolocation_state)) as state
    from sources group by 1
)

select * from renamed