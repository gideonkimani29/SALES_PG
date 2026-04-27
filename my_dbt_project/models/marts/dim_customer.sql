with customers as (
    select * from {{ ref('stg_customers') }}
),

cities as (
    select * from {{ ref('stg_cities') }}
)

select
    c.customer_id,
    c.customer_name,
    c.first_name,
    c.middle_initial,
    c.last_name,
    c.address,
    ci.city_id,
    ci.city_name,
    ci.zipcode,
    ci.country_id
from customers c
left join cities ci on c.city_id = ci.city_id
