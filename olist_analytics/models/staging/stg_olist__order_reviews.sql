with sources as (
    select * from {{ source('olist_raw', 'olist_order_reviews') }}
),

renamed as (
    select
        review_id,
        order_id,
        review_score,
        review_comment_title as comment_title,
        review_comment_message as comment_message,
        try_to_timestamp_ntz(review_creation_date) as review_creation_date,
        try_to_timestamp_ntz(review_answer_timestamp) as review_answer_timestamp
    from sources
)

select * from renamed