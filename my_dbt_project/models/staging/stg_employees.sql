with source as (
    select * from {{ source('public', 'employees') }}
)

select
    employee_id,
    first_name || ' ' || last_name         as employee_name,
    first_name,
    middle_initial,
    last_name,
    gender,
    birth_date,
    hire_date,
    city_id
from source
