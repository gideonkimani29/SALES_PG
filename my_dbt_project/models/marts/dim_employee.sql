with employees as (
    select * from {{ ref('stg_employees') }}
),

cities as (
    select * from {{ ref('stg_cities') }}
)

select
    e.employee_id,
    e.employee_name,
    e.first_name,
    e.middle_initial,
    e.last_name,
    e.gender,
    e.birth_date,
    e.hire_date,
    date_part('year', age(e.birth_date))    as age,
    date_part('year', age(e.hire_date))     as years_at_company,
    ci.city_id,
    ci.city_name,
    ci.zipcode,
    ci.country_id
from employees e
left join cities ci on e.city_id = ci.city_id
