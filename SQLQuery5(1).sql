-- segmentation our products by th cost_range
with products_cost AS (
select 
product_key,
product_name,
cost,
-- segmentation our products by th cost for each product
case when cost <100 then 'Below 100'
 when cost between 100 and 500 then '100-500'
 when cost between 500 and 1000 then '500-1000'
 else 'over 1000'
end cost_range
from gold.dim_products
)
select

cost_range,
count(product_key) as prod_num
from products_cost
group by cost_range