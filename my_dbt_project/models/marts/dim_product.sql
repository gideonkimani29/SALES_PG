with products as (
    select * from {{ ref('stg_products') }}
),

categories as (
    select * from {{ ref('stg_categories') }}
)

select
    p.product_id,
    p.product_name,
    p.price,
    p.class,
    p.resistant,
    p.is_allergic,
    p.vitality_days,
    p.modify_date,
    c.category_id,
    c.category_name
from products p
left join categories c on p.category_id = c.category_id
