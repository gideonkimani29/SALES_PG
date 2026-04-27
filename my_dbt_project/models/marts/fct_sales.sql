with sales as (
    select * from {{ ref('stg_sales') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

dim_date as (
    select * from {{ ref('dim_date') }}
)

select
    s.sales_id,
    s.transaction_number,
    s.customer_id,
    s.salesperson_id                        as employee_id,
    s.product_id,
    cu.city_id                              as location_id,
    d.date_id,
    s.sales_date,
    s.quantity,
    s.discount,
    s.total_price,
    s.total_price * s.discount              as discount_amount
from sales s
left join customers cu on s.customer_id = cu.customer_id
left join dim_date d on s.sales_date = d.full_date
