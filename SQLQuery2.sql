--(2)-- the running sales over time

-- calculate total sales per month

select
order_month,
total_sales,
sum(total_sales)over(partition by year(order_month) order by (order_month))as running_total_sales,
 avg_price, --using the window function to calculate the cumulative sales 
avg(avg_price) over (partition by year(order_month) order by (order_month))as running_avg_prices
from --using the window function to calculate the cumulative sales
(
select
datetrunc(month,order_date) as order_month, --getting the month of the date 
sum(sales_amount) as total_sales,--getting the total sales
avg(price) as avg_price --getting the avg prise
from gold.fact_sales 
where order_date is not null
group by datetrunc(month,order_date)   -- grouping the data by month

) as sub_query


