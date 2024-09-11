--Viewing thre data
select * from DATASETOnlineRetailnew --order by InvoiceNo


--Adding a Total Sales Column
alter table DATASETOnlineRetailnew
add TotalSales decimal(10,2)

update DATASETOnlineRetailnew 
set TotalSales = Quantity * UnitPrice

--Visualizing duplicates
with CTE as
(select *,ROW_NUMBER() over (partition by InvoiceNo,Stockcode,Description,Quantity,InvoiceDate,UnitPrice,CustomerID,Country order by InvoiceNo)  as rownumber 
from DATASETOnlineRetailnew)

select * from CTE 
where rownumber >1

--Deleting Duplicates (This took out 5,268 rows)
with CTE as
(select *,ROW_NUMBER() over (partition by InvoiceNo,Stockcode,Description,Quantity,InvoiceDate,UnitPrice,CustomerID,Country order by InvoiceNo)  as rownumber 
from DATASETOnlineRetailnew)

delete from CTE 
where rownumber >1

--Visualizing and removing incorrect values (10,587 rows were affected)
select * from DATASETOnlineRetailnew where
quantity<=0

delete from DATASETOnlineRetailnew 
where Quantity <=0

select * from DATASETOnlineRetailnew
where UnitPrice  <= 0

--Tried to remove data with unitprice <= 0, but had a datatype error so:
--Then I visualized it.
alter table DATASETOnlineRetailnew
alter column UnitPrice decimal(10,2)

select * from DATASETOnlineRetailnew
where UnitPrice  <= 0
--deleting........ (1,180 rows affected)
delete from DATASETOnlineRetailnew
where UnitPrice <= 0



--REPORTING

--YEARLY, MONTHLY TRENDS 

select DATENAME(YEAR,INVOICEDATE) AS YEARS, DATENAME(MONTH,InvoiceDate) as MONTHS,SUM(TotalSales) as Total_Sales
from DATASETOnlineRetailnew
group by DATENAME(YEAR,INVOICEDATE), DATENAME(MONTH, InvoiceDate), DATEPART(MONTH,INVOICEDATE)
ORDER BY YEARS, DATEPART(MONTH,InvoiceDate)

--DAILY TRENDS
select DATENAME(WEEKDAY,InvoiceDate) as DAY_OF_WEEK, sum (TotalSales) as Total_Sales
from DATASETOnlineRetailnew
GROUP BY DATENAME(WEEKDAY,InvoiceDate),DATEPART(WEEKDAY, InvoiceDate)
order by DATEPART(WEEKDAY, InvoiceDate)

--HOURLY TRENDS

select DATENAME(HOUR,InvoiceDate) as HOURS, sum (TotalSales) as Total_Sales
from DATASETOnlineRetailnew
GROUP BY DATENAME(HOUR,InvoiceDate), DATEPART(HOUR,InvoiceDate)
order by DATEPART(HOUR,InvoiceDate)



--CUSTOMER ANALYSIS
--Changing missing Customerid to Anonymous (132,186 rows were affected)
update DATASETOnlineRetailnew
set CustomerID = 'Anonymous' where CustomerID =''

--Customer Analysis (Other Than Anonymous)
select top 10 CustomerId as CustomerId, sum(TotalSales) as Total_Sales from DATASETOnlineRetailnew
where CustomerID <> 'Anonymous'
group by CustomerID
order by Total_Sales DESC



--PRODUCT ANALYSIS
--Best Selling Products based on Revenue generated
select top 10 Description, sum(totalsales) as Total_Sales from DATASETOnlineRetailnew
where Description not in ('postage','Dotcom postage','Bank Charges','Manual') --Removed these as these are not exactly products
group by Description
order by Total_Sales desc

--GEOGRAPHIC ANALYSIS
SELECT top 10 Country, SUM(TotalSales) AS TotalSales
FROM DATASETOnlineRetailnew
GROUP BY Country
ORDER BY TotalSales DESC;


--REPEAT CUSTOMERS AND RFM ANALYSIS
alter table DatasetOnlineRetailnew
alter column InvoiceDate DATETIME;


WITH ReferenceDate AS (
    SELECT MAX(InvoiceDate) AS RefDate
    FROM DATASETOnlineRetailnew)

select CustomerId, 
count(distinct (DATENAME(DAY,InvoiceDate))) as No_Of_Days, ---Counted the distinct(days) instead of the distinct(InvoiceDate) because some days had just time differences
count(distinct(InvoiceNo)) as No_of_Purchases,
SUM(TotalSales) as Total_Spent,
MIN(InvoiceDate) as First_Purchase_Date,
MAX(InvoiceDate) as Latest_Purchase_Date,
DATEDIFF(day, (select RefDate from ReferenceDate), Max(InvoiceDate)) as Recency
into #RFM_calculation
from DATASETOnlineRetailnew
where CustomerID <> 'Anonymous'
group by CustomerID
having count(distinct(DATENAME(DAY,InvoiceDate)))>1

select * from #RFM_calculation
ORDER BY No_Of_Days DESC, No_of_Purchases DESC


--TOP (50) Products associated with TOP (50) repeat customers 
	select top 50 Description, sum(Quantity) as Total_Quantity from DATASETOnlineRetailnew 
	where CustomerID in (select top 50 CustomerID from #RFM_calculation ORDER BY No_Of_Days DESC, No_of_Purchases DESC)
	group by Description
	Order by Total_Quantity DESC


--Products that are most bought together

with PRODUCT_PAIRS AS (
select a.InvoiceNo,
a.Description AS FirstProduct,
b.Description AS SecondProduct
from DATASETOnlineRetailnew a
join DATASETOnlineRetailnew b
on a.InvoiceNo = b.InvoiceNo and a.Description < b.Description --The Less down makes sure there are no duplicates
)

select CONCAT(FirstProduct, ' , ', SecondProduct) as Product_Combinations ,count(*) as Total_Combinations
from PRODUCT_PAIRS
group by  FirstProduct, SecondProduct 
order by Total_Combinations DESC 


--Normalizing the result a little further by removing as many adjectives such as (colours, Retrospot) as possible


CREATE FUNCTION dbo.NormalizeDescription (@Description VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @NormalizedDescription VARCHAR(255);
    
    SET @NormalizedDescription = @Description;
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'RED', '');
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'GREEN', '');
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'BLUE', '');
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'PINK', '');
	SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'PURPLE', '');
	SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'ORANGE', '');
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'BLACK', '');
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'WHITE', '');
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'YELLOW', '');
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'POLKADOT', '');
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'REGENCY', '');
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'BAKELIKE', '');
    SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'BAROQUE', '');
	SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'RETROSPOT', '');
	SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'ROSES', '');
	SET @NormalizedDescription = REPLACE(@NormalizedDescription, 'POLKADOT', '');




    RETURN @NormalizedDescription;
END;


with PRODUCT_PAIRS AS (
select a.InvoiceNo,
dbo.NormalizeDescription(a.Description) AS FirstProduct,
dbo.NormalizeDescription(b.Description) AS SecondProduct
from DATASETOnlineRetailnew a
join DATASETOnlineRetailnew b
on a.InvoiceNo = b.InvoiceNo and a.Description < b.Description --The Less down makes sure there are no duplicates
)

select top 10 CONCAT(FirstProduct, ' , ', SecondProduct) ,count(*) as Total_Combinations
from PRODUCT_PAIRS
where FirstProduct<>SecondProduct
group by  FirstProduct, SecondProduct 
order by Total_Combinations DESC 



-- Getting Three Products that are commonly bought together
WITH PRODUCT_TRIPLETS AS (
    SELECT 
        a.InvoiceNo,
        dbo.NormalizeDescription(a.Description) AS FirstProduct,
        dbo.NormalizeDescription(b.Description) AS SecondProduct,
        dbo.NormalizeDescription(c.Description) AS ThirdProduct
    FROM 
        DATASETOnlineRetailnew a
    JOIN 
        DATASETOnlineRetailnew b
        ON a.InvoiceNo = b.InvoiceNo AND a.Description < b.Description
    JOIN 
        DATASETOnlineRetailnew c
        ON a.InvoiceNo = c.InvoiceNo AND b.Description < c.Description AND a.Description < c.Description
)
SELECT 
    FirstProduct, 
    SecondProduct, 
    ThirdProduct, 
    COUNT(*) AS Total_Combinations
FROM 
    PRODUCT_TRIPLETS
GROUP BY 
    FirstProduct, 
    SecondProduct, 
    ThirdProduct
ORDER BY 
    Total_Combinations DESC;







	