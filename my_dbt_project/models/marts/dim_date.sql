with date_spine as (
    select
        generate_series(
            (select min(sales_date) from {{ source('public', 'sales') }}),
            (select max(sales_date) from {{ source('public', 'sales') }}),
            interval '1 day'
        )::date as date_day
)

select
    to_char(date_day, 'YYYYMMDD')::int      as date_id,
    date_day                                as full_date,
    date_part('year',  date_day)::int       as year,
    date_part('quarter', date_day)::int     as quarter,
    date_part('month', date_day)::int       as month,
    to_char(date_day, 'Month')              as month_name,
    date_part('week',  date_day)::int       as week,
    date_part('day',   date_day)::int       as day,
    to_char(date_day, 'Day')               as day_name,
    date_part('dow',   date_day)::int       as day_of_week,
    case when date_part('dow', date_day) in (0,6)
         then true else false end           as is_weekend
from date_spine
