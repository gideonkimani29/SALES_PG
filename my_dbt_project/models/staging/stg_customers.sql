with source as (
    select * from {{ source('public', 'customers') }}
)

select
    customer_id,
    first_name || ' ' || last_name         as customer_name,
    first_name,
    middle_initial,
    last_name,
    city_id,
    address
from source
