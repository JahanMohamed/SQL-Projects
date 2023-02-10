-- checking unique value 

select distinct  status from rfm_project.`rfm_ analysis`;
select distinct year_id from rfm_project.`rfm_ analysis`;
select distinct PRODUCTLINE from rfm_project.`rfm_ analysis`;
select distinct country from rfm_project.`rfm_ analysis`;
select distinct dealsize from rfm_project.`rfm_ analysis`;
select distinct TERRITORY from rfm_project.`rfm_ analysis`;

select*
from rfm_project.`rfm_ analysis`;


-- Analysis 1
-- productline by sales
select PRODUCTLINE, round(sum(sales))as revenue
from  rfm_project.`rfm_ analysis`
group by 1
order by 2 desc;

-- Analysis 2
-- sales by year

select year_id, round(sum(sales)) as revenue
from rfm_project.`rfm_ analysis`
group by 1
order by 2 desc;

-- Analysis 3
-- sales by dealsize

select DEALSIZE,round(sum(sales)) as revenue
from rfm_project.`rfm_ analysis`
group by 1
order by 2 desc;

-- Analysis 4
-- Best Month for Sales per year
with cte as (select YEAR_ID,MONTH_ID,round(sum(sales)) as revenue
from rfm_project.`rfm_ analysis`
group by 1,2
order by 1,2)

select YEAR_ID,MONTH_ID,revenue
from (select YEAR_ID,MONTH_ID,revenue,
rank() over(partition by YEAR_ID order by revenue desc) as r
from cte) x
where r=1;


with maxiam_sales as
((select MONTH_ID, round(sum(sales)) as revenue
from rfm_project.`rfm_ analysis`
where YEAR_ID=2003
group by 1
order by 2 desc
limit 1)
union 
(select MONTH_ID, round(sum(sales)) as revenue
from rfm_project.`rfm_ analysis`
where YEAR_ID=2004
group by 1
order by 2 desc
limit 1)
union 
(select MONTH_ID, round(sum(sales)) as revenue
from rfm_project.`rfm_ analysis`
where YEAR_ID=2005
group by 1
order by 2 desc
limit 1))

select*
from  maxiam_sales;

-- Analysis 5
-- what productline sell most in month

select MONTH_ID,PRODUCTLINE ,round((sum(sales))) as revenue
from rfm_project.`rfm_ analysis`
where YEAR_ID=2003 and MONTH_ID=11
group by 1,2
order by 3 desc;

select MONTH_ID,PRODUCTLINE ,round((sum(sales))) as revenue
from rfm_project.`rfm_ analysis`
where YEAR_ID=2004 and MONTH_ID=11
group by 1,2
order by 3 desc;

select MONTH_ID,PRODUCTLINE ,round((sum(sales))) as revenue
from rfm_project.`rfm_ analysis`
where YEAR_ID=2005 and MONTH_ID=5
group by 1,2
order by 3 desc;

-- Who is the best customer

with cte as (select CUSTOMERNAME, 
    round(sum(sales)) as  Monetry_Value,
    count(ORDERNUMBER) as Frequency,
    max(STR_TO_DATE(ORDERDATE, '%m/%d/%Y')) as last_order_date,
    (select max(STR_TO_DATE(ORDERDATE, '%m/%d/%Y')) from rfm_project.`rfm_ analysis`) max_order_date,
    datediff((select max(STR_TO_DATE(ORDERDATE, '%m/%d/%Y')) from rfm_project.`rfm_ analysis`),max(STR_TO_DATE(ORDERDATE, '%m/%d/%Y'))) as Recency
from rfm_project.`rfm_ analysis`
group by 1),

rfm_cal as
(select*,
ntile(4) over(order by Recency desc) as rfm_recency,
ntile(4) over(order by Frequency) as rfm_frequency,
ntile(4) over (order by Monetry_Value) as rfm_monetry
from cte)

select*
from rfm_cal




