with source as (
    select * from {{ source('public', 'cities') }}
)

select
    city_id,
    city_name,
    zipcode,
    country_id
from source
