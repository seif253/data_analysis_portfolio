--(1)--change over time analysis

select
year(order_date) as year, --getting the year of the date 
month(order_date) as month , --getting the month of the date 
sum(quantity) as total_quantity,--getting the total quantity  
sum(sales_amount) as total_sales,--getting the total sales 
count(distinct customer_key)as customers_numbers --getting the number of the customers 
from gold.fact_sales 
where order_date is not null
group by year(order_date),month(order_date) --grouping the data by year 
order by year(order_date), month(order_date) --sorting the data by year



