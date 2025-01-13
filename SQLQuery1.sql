-- Create Database
Create Database MarketBasket

-- Select All Records From the Groceries Data
Select *
From Groceriesdata

-- Format the Date and Select Relevant Fields
SELECT Member_number, CAST(Date AS DATE) AS FormattedDate, itemDescription
FROM Groceriesdata

-- Calculate Frequency of Product Pairs
SELECT GD1.itemDescription as Product1, GD2.itemDescription as Product2, COUNT(1) as Frequency
From Groceriesdata as GD1
Join Groceriesdata as GD2 ON GD1.Member_number = GD2.Member_number
Where GD1.itemDescription > GD2.itemDescription
Group By GD1.itemDescription, GD2.itemDescription

-- Calculate Number of Transactions
SELECT 
    GD1.itemDescription AS Product1, 
    GD2.itemDescription AS Product2, 
    COUNT(1) AS Frequency,
    (SELECT COUNT(Member_number) FROM Groceriesdata) AS TotalTransactions
FROM Groceriesdata AS GD1
JOIN Groceriesdata AS GD2 
    ON GD1.Member_number = GD2.Member_number
WHERE GD1.itemDescription > GD2.itemDescription
GROUP BY GD1.itemDescription, GD2.itemDescription

-- Create a New Table to Calculate Support and Confidence
With Market as (
			SELECT 
    GD1.itemDescription AS Product1, 
    GD2.itemDescription AS Product2, 
    COUNT(1) AS Frequency,
    (SELECT COUNT(Member_number) FROM Groceriesdata) AS TotalTransactions
FROM Groceriesdata AS GD1
JOIN Groceriesdata AS GD2 
    ON GD1.Member_number = GD2.Member_number
WHERE GD1.itemDescription > GD2.itemDescription
GROUP BY GD1.itemDescription, GD2.itemDescription
		)
Select Product1, Product2, Frequency
From Market


-- Calculate Support
With Market as (
			SELECT 
    GD1.itemDescription AS Product1, 
    GD2.itemDescription AS Product2, 
    COUNT(1) AS Frequency,
    (SELECT COUNT(Member_number) FROM Groceriesdata) AS TotalTransactions
FROM Groceriesdata AS GD1
JOIN Groceriesdata AS GD2 
    ON GD1.Member_number = GD2.Member_number
WHERE GD1.itemDescription > GD2.itemDescription
GROUP BY GD1.itemDescription, GD2.itemDescription
		)
Select Product1, Product2, Frequency, 
		Format(Frequency*100.00/TotalTransactions, '0.##') as Support
From Market

-- Calculate Confidence
With Market as (
			SELECT 
    GD1.itemDescription AS Product1, 
    GD2.itemDescription AS Product2, 
    COUNT(1) AS Frequency,
    (SELECT COUNT(Member_number) FROM Groceriesdata) AS TotalTransactions,
	(SELECT Count(Member_number) From Groceriesdata Pr WHERE GD1.itemDescription = Pr.itemDescription) as Frequency_lhs
FROM Groceriesdata AS GD1
JOIN Groceriesdata AS GD2 
    ON GD1.Member_number = GD2.Member_number
WHERE GD1.itemDescription > GD2.itemDescription
GROUP BY GD1.itemDescription, GD2.itemDescription
		)
Select Product1, Product2, Frequency, 
		Format(Frequency*100.00/TotalTransactions, '0.##') as Support,
		Format(Frequency*100.00/Frequency_lhs, '0.##') as Confidence
From Market

-- Calculate Support(Product1)
WITH Market AS (
    SELECT 
        GD1.itemDescription AS Product1, 
        GD2.itemDescription AS Product2, 
        COUNT(1) AS Frequency,
        (SELECT COUNT(Member_number) FROM Groceriesdata) AS TotalTransactions,
        (SELECT COUNT(Member_number) 
         FROM Groceriesdata Pr 
         WHERE GD1.itemDescription = Pr.itemDescription) AS Frequency_lhs
    FROM Groceriesdata AS GD1
    JOIN Groceriesdata AS GD2 
        ON GD1.Member_number = GD2.Member_number
    WHERE GD1.itemDescription > GD2.itemDescription
    GROUP BY GD1.itemDescription, GD2.itemDescription
)
SELECT 
    Product1, 
    Product2, 
    Frequency, 
    FORMAT(Frequency * 100.00 / TotalTransactions, '0.##') AS Support,
    FORMAT(Frequency * 100.00 / Frequency_lhs, '0.##') AS Confidence,
    Frequency_lhs * 100.00 / TotalTransactions AS Support1
FROM Market;

-- Calculate Support(Product2)
WITH Market AS (
    SELECT 
        GD1.itemDescription AS Product1, 
        GD2.itemDescription AS Product2, 
        COUNT(1) AS Frequency,
        (SELECT COUNT(Member_number) FROM Groceriesdata) AS TotalTransactions,
        (SELECT COUNT(Member_number) 
         FROM Groceriesdata Pr 
         WHERE GD1.itemDescription = Pr.itemDescription) AS Frequency_lhs,
		 (SELECT COUNT(Member_number) 
         FROM Groceriesdata Pr 
         WHERE GD2.itemDescription = Pr.itemDescription) AS Frequency_rhs
    FROM Groceriesdata AS GD1
    JOIN Groceriesdata AS GD2 
        ON GD1.Member_number = GD2.Member_number
    WHERE GD1.itemDescription > GD2.itemDescription
    GROUP BY GD1.itemDescription, GD2.itemDescription
)
SELECT 
    Product1, 
    Product2, 
    Frequency, 
    FORMAT(Frequency * 100.00 / TotalTransactions, '0.##') AS Support,
    FORMAT(Frequency * 100.00 / Frequency_lhs, '0.##') AS Confidence,
    Frequency_lhs * 100.00 / TotalTransactions * Frequency_rhs * 100.00 / TotalTransactions AS Support2
FROM Market

-- Calculate Lift
WITH Market AS (
    SELECT 
        GD1.itemDescription AS Product1, 
        GD2.itemDescription AS Product2, 
        COUNT(1) AS Frequency,
        (SELECT COUNT(Member_number) FROM Groceriesdata) AS TotalTransactions,
        (SELECT COUNT(Member_number) 
         FROM Groceriesdata Pr 
         WHERE GD1.itemDescription = Pr.itemDescription) AS Frequency_lhs,
		 (SELECT COUNT(Member_number) 
         FROM Groceriesdata Pr 
         WHERE GD2.itemDescription = Pr.itemDescription) AS Frequency_rhs
    FROM Groceriesdata AS GD1
    JOIN Groceriesdata AS GD2 
        ON GD1.Member_number = GD2.Member_number
    WHERE GD1.itemDescription > GD2.itemDescription
    GROUP BY GD1.itemDescription, GD2.itemDescription
)
SELECT 
    Product1, 
    Product2, 
    Frequency, 
    FORMAT(Frequency * 100.00 / TotalTransactions, '0.##') AS Support,
    FORMAT(Frequency * 100.00 / Frequency_lhs, '0.##') AS Confidence,
    FORMAT(Frequency * 100.00/ TotalTransactions / (Frequency_lhs * 100.00 / TotalTransactions) * (Frequency_rhs * 100.00 / TotalTransactions), '0.##') AS Lift
FROM Market



-- Top 10 Frequently Bought Product Pairs
WITH Market AS (
    SELECT 
        GD1.itemDescription AS Product1, 
        GD2.itemDescription AS Product2, 
        COUNT(1) AS Frequency,
        (SELECT COUNT(Member_number) FROM Groceriesdata) AS TotalTransactions,
        (SELECT COUNT(Member_number) 
         FROM Groceriesdata Pr 
         WHERE GD1.itemDescription = Pr.itemDescription) AS Frequency_lhs,
		 (SELECT COUNT(Member_number) 
         FROM Groceriesdata Pr 
         WHERE GD2.itemDescription = Pr.itemDescription) AS Frequency_rhs
    FROM Groceriesdata AS GD1
    JOIN Groceriesdata AS GD2 
        ON GD1.Member_number = GD2.Member_number
    WHERE GD1.itemDescription > GD2.itemDescription
    GROUP BY GD1.itemDescription, GD2.itemDescription
)
SELECT 
    TOP (10) Product1, 
    Product2, 
    Frequency, 
    FORMAT(Frequency * 100.00 / TotalTransactions, '0.##') AS Support,
    FORMAT(Frequency * 100.00 / Frequency_lhs, '0.##') AS Confidence,
    FORMAT(Frequency * 100.00/ TotalTransactions / (Frequency_lhs * 100.00 / TotalTransactions) * (Frequency_rhs * 100.00 / TotalTransactions), '0.##') AS Lift
FROM Market
ORDER BY Frequency DESC