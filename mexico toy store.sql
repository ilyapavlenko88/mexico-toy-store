
--cleaning data --
UPDATE products set Product_Cost=replace(Product_Cost,'$','')
where Product_Cost like '%$%'


UPDATE products
SET Product_Cost = (CASE WHEN ISNUMERIC(Product_Cost)=1 THEN CAST(CAST(Product_Cost AS FLOAT) AS INT)END )

ALTER TABLE products
ALTER COLUMN Product_Cost INT
select*from products

select*from [dbo].[stores]

update [dbo].[stores]
set Store_name=  TRANSLATE (Store_name,'0123456789', '          ') 

--convert date from table stores--

select Store_Open_Date,CONVERT(date,Store_Open_Date) 
from [dbo].[stores]

update [dbo].[stores]
set Store_Open_Date=CONVERT(date,Store_Open_Date)

alter table [dbo].[stores]
add Store_open date;

update [dbo].[stores]
set Store_open=CONVERT(date,Store_Open_Date)

--convert date from table sales--

select*from sales

select date,CONVERT(date,date) 
from sales

update sales
set date=CONVERT(date,date)

alter table sales
add date_sale date;

update sales
set date_sale=CONVERT(date,date)



--Are sales being lost with out-of-stock products at certain locations?-

with cte as (
select distinct t3.Store_Location,   t1.Product_Name, t2.Stock_On_Hand
from [dbo].[products] t1 join [dbo].[inventory] t2
on t1.Product_ID=t2.Product_ID
join [dbo].[stores] t3
on t3.Store_ID=t2.Store_ID
where t2.Stock_On_Hand=0)

select Store_Location,count(store_location) as cntLoc
from cte
group by Store_Location
order by 2 desc



--Which product categories drive the biggest profits? Is this the same across store locations?--

select  t1.[Product_Name] ,t1.Product_Category, sum((t1.product_price*t2.units)-(t1.product_cost*t2.units)) as sumProfit
from [dbo].[products] t1 join [dbo].[sales] t2
on t1.Product_ID=t2.Product_ID
group by t1.Product_Category,t1.[Product_Name]
order by 3 desc



--Can you find any seasonal trends or patterns in the sales data?--


select
sum(case when datepart (QQ,[date_sale]) =1 then units else 0 end) as 'Profit 1 Quarter',
sum(case when datepart (QQ,[date_sale]) =2 then units else 0 end) as 'Profit 2 Quarter',
sum(case when datepart (QQ,[date_sale]) =3 then units else 0 end) as 'Profit 3 Quarter',
sum(case when datepart (QQ,[date_sale]) =4 then units else 0 end) as 'Profit 4 Quarter'
from sales




