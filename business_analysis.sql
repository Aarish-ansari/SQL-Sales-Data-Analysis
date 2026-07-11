create database Client_data;
use Client_data;
SELECT * from Data;
-- Find the Top 10 best-selling products based on quantity sold

select Product , sum(Quantity) as Total_quantity 
from Data 
GROUP BY Product
order by sum(Quantity) desc
limit 10;
-- Find the Top 10 products generating maximum revenue.
select Product , sum(Amount) as 'Revenue'
from Data 
GROUP BY Product
order by sum(Amount) desc 
limit 10;
-- Top 2 best Product Month Wise
select Month,Product,Total_Qunatity from (
select monthname(Order_Date) as 'Month' , Product , sum(Quantity) as 'Total_Qunatity',
DENSE_RANK() over(PARTITION BY monthname(Order_Date) order by sum(Quantity) desc ) as Rnk
from Data
GROUP BY monthname(Order_Date),Product) as t 
where t.Rnk<3;
-- Calculate the Month-on-Month (MoM) Revenue Growth (%) for the business. 

select monthname(Order_Date) as 'Month' , sum(Amount) as 'revenue' , 
concat(Round(((sum(Amount)-lag(sum(Amount)) over(order by sum(Amount) desc))
/(lag(sum(Amount)) over(order by sum(Amount) desc)))*100,2),"%")as "GrowthMoM"
from Data 
GROUP BY monthname(Order_Date);



-- Avg highest product 
select Product , avg(Amount) as 'Avg_amount'
from  Data
group by Product 
order by Avg_amount desc;
-- By Customer Analysis 
-- Find the Top 10 customers by total spending. 
select Customer_Name, sum(Amount) as "total_amount"
from Data
GROUP BY Customer_Name
order by total_amount desc
limit 10;

select Cutomer_Name, count(*) as 'visit'
from Data 
GROUP BY Cutomer_Name
having count(*)>1
order by visit desc;
select Cutomer_Name , avg(Amount) as 'Avg_amount'
from  Data
group by Cutomer_Name
order by Avg_amount desc;
alter table Data RENAME column Cutomer_Name to Customer_Name ;
with cte as (
select Customer_Name , sum(Amount) as 'Total_amount' 
from Data 
GROUP BY Customer_Name ) 
select Customer_Name from cte where Total_amount>(
select (avg(Total_amount)/2) from cte);
SELECT Customer_Name , count(DISTINCT Product) as "Freqency" 
from Data 
GROUP BY  Customer_Name ;
WITH cte AS (
    SELECT
        Customer_Name,
        COUNT(DISTINCT Product) AS Different_Products
    FROM Data
    GROUP BY Customer_Name
)

SELECT *
FROM cte
WHERE Different_Products = (
    SELECT MAX(Different_Products)
    FROM cte
);
SELECT City , sum(amount) as 'Revenue' 
from Data 
group by City
order by  sum(amount) desc
limit 1;
select City , count(*) as "Order" 
from Data
GROUP BY City ;
SELECT City , (sum(Amount)/(select sum(Amount) 
from Data))*100 as 'Per'
from Data
GROUP BY City
order by Per desc;
select City , Product from (
select City , Product , sum(Quantity) as 'Total_Qunatity' , DENSE_RANK() over(PARTITION BY City order by sum(Quantity)  desc ) as rnk 
from Data 
group by City , Product
order by City) as t
where t.rnk=1;
select City , Product from (
select City , Product , sum(Amount) as 'Total_Amount' , DENSE_RANK() over(PARTITION BY City order by sum(Amount)  desc ) as rnk 
from Data 
group by City , Product
order by City) as t
where t.rnk<4;
select Order_Details ,count(*) 
from Data 
GROUP BY Order_Details ;
SELECT
    d1.Product AS Product_1,
    d2.Product AS Product_2,
    COUNT(*) AS Frequency
FROM Data d1
JOIN Data d2
    ON d1.Order_Details= d2.Order_Details
   AND d1.Product <d2.Product
GROUP BY Product_1, Product_2
ORDER BY Frequency DESC;
-- Find the Top highest revenue months
SELECT * from Data;
select monthname(Order_Date) as 'Month', sum(Amount) As 'Revenue' 
from Data 
group by monthname(Order_Date)
order by sum(Amount) DESC;
-- Which payment mode is used most frequently? 
SELECT Payment_Mode , count(*) as "Freqency" 
from Data 
group by Payment_Mode 
order by Freqency desc;
-- Find the largest order placed in terms of Amount.
select Order_Details,Order_Date, Customer_Name , Product , max(Amount) as 'Max_Amount' 
from  Data 
group by Order_Details,Order_Date, Customer_Name , Product
order by Max_Amount desc
limit 1;


