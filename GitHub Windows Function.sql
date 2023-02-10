-- use aggregate function with windows function

select*,
max(cost_per_box) over(partition by Category order by Cost_per_box desc)
from products;

-- row_number, rank, dense_rank

select*,
row_number() over(partition by category order by cost_per_box desc)  rn,
rank() over(partition by Category order by cost_per_box desc) rnk,
dense_rank() over(partition by Category order by cost_per_box desc) d_rnk
from products;

-- Hint;
-- in this example we can't different row number, rank, dense rank together bcz cost_per_box amount same


-- lead, lag 

select*,
lag(cost_per_box) over (partition by Category order by PID)
from products;

select*,
lag(cost_per_box,2) over (partition by Category order by PID)
from products;

select*,
lead(cost_per_box) over (partition by category order by PID)
from products;

select*,
lag(cost_per_box) over (partition by Category order by PID),
case when cost_per_box >lag(cost_per_box) over (partition by Category order by PID) then 'higher than previous cost'
when cost_per_box <lag(cost_per_box) over (partition by Category order by PID) then 'lower than previous cost'
when cost_per_box =lag(cost_per_box) over (partition by Category order by PID) then 'same cost'
end as 'range of product'
from products;


-- first_value
select *,
first_value(product) over (partition by Category order by cost_per_box desc)
from products;


-- least_value

select*,
last_value(product) over 
(partition by category order by cost_per_box asc
range between unbounded preceding and unbounded following) as least_product
from products;


-- frame clause
-- whenever we use last_value function then we can use frame clause
-- range between unbounded preceding and unbounded following

-- Alternative way write the sql query

select *,
first_value(product) over w as expensive_peoduct,
last_value(product) over w as cheap_product
from products
window w as (partition by category order by cost_per_box desc
			 range between unbounded preceding and unbounded following);
             


-- nth value
select*,
nth_value(product,2) over(partition by category order by cost_per_box desc
			 range between unbounded preceding and unbounded following) as 2nd_most_expensive_product
from products;


-- altrenatve way of nth_value query
select*,
nth_value(product,2) over w as 2nd_most_expensive_product
from products
window w as (partition by category order by cost_per_box desc
			 range between unbounded preceding and unbounded following)	;
             
             
--  NTILE

select*,
ntile(3) over (order by cost_per_box desc) as bucket 
from products;


select *,
case when x.bucket=1 then 'Expensive Product'
	 when x.bucket=2 then 'Middle Range Product'
     when x.bucket=3 then 'Cheaper Product'
     end as Range_of_Product
from (select*,
ntile(3) over (order by cost_per_box desc) as bucket 
from products) x; 


-- cume_dist

select*,
cume_dist() over (order by Cost_per_box desc) as cume_distribution,
round(cume_dist() over (order by Cost_per_box desc )*100, 2) as cume_distribution
from products ;


select*,
percent_rank() over (order by cost_per_box) as prec_rank,
round(percent_rank() over (order by cost_per_box) *100, 2) per_rank
from products;






