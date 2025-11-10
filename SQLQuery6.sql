-- a report about the customers 
create view gold.report_customers as

with base_query as (
select 
f.product_key,
f.sales_amount,
f.order_date,
f.quantity,
concat(first_name,' ',last_name) as customer_name,
f.customer_key,
c.first_name,
c.customer_number,
c.last_name,

datediff(YEAR,birthdate,GETDATE()) age,
f.order_number,
c.birthdate
from gold.fact_sales f 
left join gold.dim_customers c
on f.customer_key=c.customer_key
where f.order_date is not null
)
select 
customer_key,
customer_number,
customer_name,
age,
sum(sales_amount) as total_sales ,
sum(quantity) as total_quantity,
datediff(month,min(order_date),max(order_date)) as lifespan ,
count(order_number) as total_orders,
case when sum(sales_amount)> 5000 and datediff(month,min(order_date),max(order_date)) >=12 then 'vip'
 when sum(sales_amount) <= 5000 and datediff(month,min(order_date),max(order_date)) >=12 then 'Regular'
 else 'new'
 end customers_segs,
count(product_key) as total_products,
case
	when age between 30 and 39 then '30:39'
	when age between 40 and 49 then '40:49'
	when age between 20 and 29 then '20:29'
	else 'above 50'
end age_segments,
datediff(month,max(order_date),getdate()) as recency,
case 
	when sum(sales_amount) = 0 then 0
    else sum(sales_amount)/count(order_number) 
	end 'average _order_value',
case 
	when datediff(month,min(order_date),max(order_date)) = 0 then sum(sales_amount)
    else sum(sales_amount)/ datediff(month,min(order_date),max(order_date))
end 'average _monthly_sales'


from base_query 
group by 
customer_key,
customer_name,
customer_number,
age


