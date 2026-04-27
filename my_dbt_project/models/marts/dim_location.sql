with cities as (
    select * from {{ ref('stg_cities') }}
)

select
    city_id         as location_id,
    city_id,
    city_name,
    zipcode,
    country_id
from cities
