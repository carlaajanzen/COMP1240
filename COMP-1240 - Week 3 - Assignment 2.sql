USE AdventureWorks2016
GO

/*
1. List the sales person and their sales quota
*/

-- Ordered by the Last name of the Salesperson for the most user-friendly presentation
SELECT (P.LastName + ', ' + P.FirstName + ' ' + ISNULL(P.MiddleName, '')) AS SalesPerson, S.SalesQuota
FROM Person.Person AS P
JOIN Sales.SalesPerson AS S
ON P.BusinessEntityID = S.BusinessEntityID
ORDER BY SalesPerson;

/*
2. List the vendors that have no products
*/

-- Ordered by Vendor name for the most user-friendly presentation
SELECT V.Name AS Vendor, COUNT(P.ProductID) AS ProductCount
FROM Purchasing.Vendor AS V
LEFT JOIN Purchasing.ProductVendor AS P
ON V.BusinessEntityID = P.BusinessEntityID
GROUP BY V.Name
HAVING COUNT(P.ProductID) = 0
ORDER BY Vendor;

/*
3. List the Sales employees and their sales ytd with the Purchasing employees 
and their total due ytd (assuming the year is 2013 based on when it was ordered).
Have the results listed in the same columns.
*/

/*
N.B. To ensure user-friendly results, I have included an additional column called "Employee Type" 
so one can distinguish if the employee is being evaluated by their Sales YTD or Purchases YTD.
Ordered by Employee last name for user-friendly presentation
*/ 

SELECT (P.LastName + ', ' + P.FirstName + ' ' + ISNULL(P.MiddleName, '')) AS Employee, 'Sales' AS EmployeeType, S.SalesYTD AS SalesOrPurchasesYTD
FROM Person.Person AS P
JOIN Sales.SalesPerson AS S
ON P.BusinessEntityID = S.BusinessEntityID
UNION ALL
SELECT (P.LastName + ', ' + P.FirstName + ' ' + ISNULL(P.MiddleName, '')) AS Employee, 'Purchasing' AS EmployeeType, SUM(B.TotalDue) AS SalesOrPurchasesYTD
FROM Person.Person AS P
JOIN Purchasing.PurchaseOrderHeader AS B
ON P.BusinessEntityID = B.EmployeeID
WHERE B.OrderDate BETWEEN '2013-01-01' AND '2013-12-31'
GROUP BY P.FirstName, P.MiddleName, P.LastName
ORDER BY Employee;


/*
4. List the orders customer name, order status, date ordered, count of items on the order, 
and average quantity ordered where the count of items on the order is greater than 300.
*/

-- Changed the "Status" from a numeric value to the underlying meaning for user-friendly presentation
SELECT (P.LastName + ', ' + P.FirstName + ' ' + ISNULL(P.MiddleName, '')) AS CustomerName, Status =
	CASE H.Status
		WHEN 1 THEN 'In Process'
		WHEN 2 THEN 'Approved'
		WHEN 3 THEN 'Backordered'
		WHEN 4 THEN 'Rejected'
		WHEN 5 THEN 'Shipped'
		WHEN 6 THEN 'Cancelled'
		ELSE ' '
	END
	, H.OrderDate, SUM(D.OrderQty) AS 'ItemCount', AVG(D.OrderQty) AS 'AvgOtyOrdered'
FROM Sales.SalesOrderHeader AS H
JOIN Sales.SalesOrderDetail AS D
ON H.SalesOrderID = D.SalesOrderID
JOIN Sales.Customer AS C
ON C.CustomerID = H.CustomerID
JOIN Person.Person AS P
ON P.BusinessEntityID = C.PersonID
GROUP BY C.PersonID, P.LastName, P.FirstName, P.MiddleName, H.SalesOrderID, H.Status, H.OrderDate
HAVING SUM(D.OrderQty) > 300
ORDER BY CustomerName;