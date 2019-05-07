USE AdventureWorks2016;
GO

/*
1. List the products that only have a primary photo.
*/

SELECT Name AS ProductWithPrimPhoto
FROM Production.Product AS Product
WHERE EXISTS 
	(SELECT *
	FROM Production.ProductProductPhoto
	WHERE [Primary] = 1)
ORDER BY Name;

/*
2. List the reasons work was scrapped on work started between June 1 2011 and June 7 2011.
*/

SELECT Name AS ScrapReason
FROM Production.ScrapReason
WHERE ScrapReasonID IN 
	(SELECT ScrapReasonID
	FROM Production.WorkOrder
	WHERE StartDate Between '2011-06-01' AND '2011-06-07')
GROUP BY Name
ORDER BY Name;

/*
3. List the vendors whose products have been sold in a quantity greater than 15 per sale.
*/

SELECT Name AS Vendor
FROM Purchasing.Vendor
WHERE BusinessEntityID IN 
	(SELECT BusinessEntityID
	FROM Purchasing.ProductVendor
	WHERE ProductID IN 
		(SELECT ProductID
		FROM Sales.SalesOrderDetail
		WHERE OrderQty > 15))
ORDER BY Name;