-- Cleaning Data

-- Total Records = 541909
-- 135080 rows have no CustomerID
-- 406829 have CustomerID
With Online_Retail As
(
SELECT  [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [PortfolioProject].[dbo].[Online Retail]
  Where CustomerID  IS NOT NULL
  ), Quantity_Unit_Price AS
  (
  --397884 records with Quantiy and UnitPrice
  Select *
  From Online_Retail
  Where Quantity > 0 and UnitPrice > 0
  ), 


  Dup_check as
  (
  --Duplicate Check
  Select * , ROW_NUMBER() Over( partition by InvoiceNo, StockCode, Quantity order by InvoiceDate) as Dup_flag
  from Quantity_Unit_Price
  )
  -- 392669 Clean Data
  -- 5215 Duplicate Data
 
	Select * 
	Into #Online_Retail_Main
	From  Dup_check
	Where Dup_flag = 1
  
  -- Clean Data
  -- Begin Chohort Analysis
   Select * 
   From #Online_Retail_Main
  -- Unique Identifier(CustomerID)
  -- Intial Start Date(First Invoice Date)
  -- Revenue Data

  Select 
  CustomerID,
  Min(InvoiceDate) FirstPurchaseDate,
  DATEFROMPARTS(Year(Min(InvoiceDate)), Month(Min(InvoiceDate)),1) Cohort_Date
  into #Cohort
  From #Online_Retail_Main
  Group By CustomerID

  Select * 
  From #Cohort

  --Cohort Index
 Select
	 mmm.*,
	 cohort_index = year_diff * 12 + month_diff + 1
	 into #cohort_retention
	From 
		(Select
	  mm.*,
	  year_diff = Invoice_Year - Cohort_Year,
	  month_diff = Invoice_Month - Cohort_month
	  From (Select
		  m.*,
		  c.Cohort_Date,
		  year(m.InvoiceDate) Invoice_Year,
		  month(m.InvoiceDate) Invoice_Month,
		  year(c.Cohort_Date) Cohort_Year,
		  month(C.Cohort_date) Cohort_Month

	  from #Online_Retail_Main m
	  left join #Cohort c
	  on m.CustomerID = c.CustomerID
	  )mm
	  
	)mmm
--Where CustomerID = 14733


-- Pivot Data To see the Cohort Table

Select * 
into #cohort_pivot
From	
	(Select distinct
		   CustomerID,
		   Cohort_Date,
		   cohort_index
	From #cohort_retention
	 )tbl

Pivot(
	Count(CustomerId)
	for cohort_index In
		(
			[1],
			[2],
			[3],
			[4],
			[5],
			[6],
			[7],
			[8],
			[9],
			[10],
			[11],
			[12],
			[13])
			) as pivot_table
			--order by 1


Select * 
from #cohort_pivot
	order by 1

Select Cohort_Date ,
1.0 * [1]/[1] *100, 
1.0 * [2]/[1] *100,
1.0 * [3]/[1] *100,
1.0 * [4]/[1] *100,
1.0 * [5]/[1] *100,
1.0 * [6]/[1] *100,
1.0 * [7]/[1] *100,
1.0 * [8]/[1] *100,
1.0 * [9]/[1] *100,
1.0 * [10]/[1] *100,
1.0 * [11]/[1] *100,
1.0 * [12]/[1] *100,
1.0 * [13]/[1] *100
from #cohort_pivot
	order by 1

