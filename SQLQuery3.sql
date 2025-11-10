--(3)--performance analysis
--comparing sales of product with the average of sales of this product and the sales of previous year

WITH yearly_product_info AS (
select
YEAR(f.order_date) as order_year, --getting the year of the date 
p.product_name, 
SUM(f.sales_amount) as total_sales 
from gold.fact_sales f
LEFT JOIN gold.dim_products p
on p.product_key=f.product_key
WHERE f.order_date is not null
GROUP BY year(f.order_date),
p.product_name
)

select 
order_year ,
product_name ,
total_sales ,

--using window function to calculate the cumulative avg sales over years for each produc
AVG(total_sales) OVER (PARTITION BY product_name) as avg_sales ,
total_sales - avg(total_sales) over ( PARTITION BY product_name) as diff_avarege ,
--segminting the value of the sales compared to the avg sales 
CASE   
WHEN total_sales - avg(total_sales) over ( PARTITION BY product_name) > 0 then 'high'
when total_sales - avg(total_sales) over ( PARTITION BY product_name) < 0 then 'low'
else 'medium'
end avg_change ,

--using window function to calculate the cumulative avg sales over years for each produc
LAG(total_sales) OVER (PARTITION BY product_name ORDER BY ORDER_YEAR) as py_sales,
total_sales - (LAG(total_sales) OVER (PARTITION BY product_name ORDER BY ORDER_YEAR)) as diff_py,
--segminting the value of the sales compared to the last year
case
when total_sales - (LAG(total_sales) OVER (PARTITION BY product_name ORDER BY ORDER_YEAR))>0 then 'increase'
when total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY ORDER_YEAR) < 0 then 'decrease'
else 'no_change'
end AS py_change 

from yearly_product_info
order by order_year
