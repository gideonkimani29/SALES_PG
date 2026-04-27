with source as (
    select * from {{ source('public', 'products') }}
)

select
    product_id,
    product_name,
    price,
    category_id,
    class,
    modify_date,
    resistant,
    is_allergic,
    vitality_days
from source
