SELECT * FROM alfido_churn_pro.ecommerce_customer_data_large;

-----------------------------------------------------------------------------------------------------------------------------------------------------
                                       --  CREATE DUPLICATE TABLE FOR EDA ---
-----------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE churn_pro
LIKE ecommerce_customer_data_large;

INSERT INTO churn_pro
SELECT *
FROM ecommerce_customer_data_large;


-----------------------------------------------------------------------------------------------------------------------------------------------------
                                       --  CHECKING THE DUPLICATE VALUES ---
-----------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *,
	ROW_NUMBER() OVER (PARTITION BY `Customer ID`, `Purchase Date`, `Product Category`, `Product Price`, Quantity, `Total Purchase Amount`,
    `Payment Method`, `Customer Age`, `Customer Name`, Age, Gender, Churn) AS Row_Num
FROM churn_pro;

WITH CTE_dup AS
(
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY `Customer ID`, `Purchase Date`, `Product Category`, `Product Price`, Quantity, `Total Purchase Amount`,
    `Payment Method`, `Customer Age`, `Customer Name`, Age, Gender, Churn) AS Row_Num
FROM churn_pro
)
SELECT *
FROM CTE_dup 
	WHERE Row_Num > 1;


-----------------------------------------------------------------------------------------------------------------------------------------------------
                                       -- DATA CLEANING PROCESSING --
-----------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT 
COUNT(`Customer ID`)
FROM churn_pro;

SELECT 
DISTINCT(`Product Category`)
FROM churn_pro;

SELECT 
DISTINCT(`Payment Method`)
FROM churn_pro;

SELECT DISTINCT
COUNT(`Customer Name`)
FROM churn_pro;


---------------------------------------------------------------------------------------------------------------------------------------------------
                                           --   TOTAL CUSTOMER CHURN BY GENDER --
--------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	COUNT(Churn) AS Total_Customer
FROM churn_pro
	WHERE Churn = 1;


SELECT Gender,
	COUNT(Churn) AS Tot_Churn
FROM churn_pro
	WHERE Churn = 1
	GROUP BY Gender 
    ORDER BY Tot_Churn DESC;
    
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                           --   TOTAL CUSTOMER BY GENDER --
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT Gender,
	COUNT(Gender) AS Tot_Gender
FROM churn_pro
	GROUP BY Gender
    ORDER BY Tot_Gender;
    
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
									--   TOTAL QUANTITY SOLD AND QUANTITY SOLD BY PRODUCT CATEGORY --
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT SUM(Quantity) AS Total_Qty
FROM churn_pro;

SELECT `Product Category`,
	SUM(Quantity) AS Total_Quantity_Sold
FROM churn_pro
	GROUP BY `Product Category`
    ORDER BY Total_Quantity_Sold DESC;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
								  -- TOTAL AMOUNT PURCHASE ON PRODUCT CATEGORY ---
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT SUM(`Total Purchase Amount`)
FROM churn_pro;


SELECT DISTINCT `Product Category`,
		SUM(`Total Purchase Amount`) AS Total_Purchase_Category
FROM churn_pro
	GROUP BY `Product Category`
    ORDER BY Total_Purchase_Category DESC;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
								  -- NUMBER OF PURCHASE BY DIFFERENT PAYMENT METHOD ---
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT `Payment Method`,
	SUM(Quantity) AS Total_Qty
FROM churn_pro 
	GROUP BY `Payment Method`
    ORDER BY Total_Qty DESC;
    

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
								  -- GROUPING CUSTOMER BASE ON THEIR AGE  GROUP ---
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT(`Customer Age`)
FROM churn_pro
ORDER BY `Customer Age`;

ALTER TABLE churn_pro
ADD COLUMN Age_Category VARCHAR(20);

UPDATE churn_pro
SET Age_Category = 'Adult'
WHERE `Customer Age` <= 30;

UPDATE churn_pro
SET Age_Category = 'Elder'
WHERE `Customer Age` >=  31;

UPDATE churn_pro
SET Age_Category = 'Senior Citizen'
WHERE `Customer Age` >= 56;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
								  -- TOTAL QUANTITY MADE BY CUSTOMER AGE CATEGORY ---
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT Age_Category,
	SUM(Quantity) AS Tot_Qty
FROM churn_pro
	GROUP BY Age_Category
    ORDER BY Tot_Qty DESC;
    



-------------------------------------------------------------------------------------------------------------------------------------------------------------------
								  -- -- TOTAL AMOUNT PURCHASED MADE BY CUSTOMER AGE CATEGORY --- ---
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT Age_Category,
	SUM(`Total Purchase Amount`) AS Tot_Qty
FROM churn_pro
	GROUP BY Age_Category
    ORDER BY Tot_Qty DESC;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
								  -- -- TOTAL CUSTOMER CHURN BY AGE CATEGORY --- ---
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT Age_Category,
	COUNT(`Churn`) AS Tot_Churn_Cat
FROM churn_pro
	WHERE Churn = 1
	GROUP BY Age_Category
    ORDER BY Tot_Churn_Cat DESC;

















SELECT *
FROM churn_pro;







