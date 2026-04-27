with source as (
    select * from {{ source('public', 'sales') }}
)

select
    sales_id,
    salesperson_id,
    customer_id,
    product_id,
    quantity,
    discount,
    total_price,
    sales_date,
    transaction_number
from source
