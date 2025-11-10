-- segmenting the customers by the sales and the lifespan !!

 with customers_info as(
select 
c.customer_key,
min(f.order_date) as first_order,
max(order_date) as last_order,
sum(sales_amount) as total_sales,
datediff(month,min(f.order_date),max(order_date)) as lifespane_months 
from gold.dim_customers c 
left join gold.fact_sales f
on c.customer_key = f.customer_key
group by c.customer_key )

select
customers_segs ,
count(customer_key) as c_number
from(
select 
customer_key ,
lifespane_months,
total_sales,
case when total_sales > 5000 and lifespane_months >=12 then 'vip'
 when total_sales <= 5000 and lifespane_months >=12 then 'Regular'
 else 'new'
 end customers_segs
from customers_info) as sub
group by customers_segs
