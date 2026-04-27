with source as (
    select * from {{ source('public', 'categories') }}
)

select
    category_id,
    category_name
from source
