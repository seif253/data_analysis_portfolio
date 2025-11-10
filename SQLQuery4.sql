-- which category contribute the most sales ?

WITH category_sales AS (
select
p.category,
sum(f.sales_amount) as sales
from gold.fact_sales f
left join gold.dim_products p
on f.product_key= p.product_key 
group by category)
 
 select
 category,
 sales,
 sum(sales) OVER() as total_sales,
 concat(round(cast(sales as float)/ sum(sales) OVER()*100,2),'%') as perc
 from category_sales
 order by perc 