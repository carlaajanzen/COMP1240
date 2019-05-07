USE AdventureWorks2016;

/* 
1. List all the ProductModelID's where the list price is less than $10 and more than $0, 
display each ProductModelID only once. 
Order by the ProductModelID
*/ 

SELECT DISTINCT ProductModelID
FROM Production.Product
WHERE ListPrice BETWEEN 0 and 10
ORDER BY ProductModelID;

/*
2. Create a list of the sales order numbers for orders not ordered online and not with a credit card. 
Note: 0 is false and 1 is true for bit fields.
*/

SELECT SalesOrderNumber
FROM Sales.SalesOrderHeader
WHERE OnlineOrderFlag = 0 AND CreditCardID IS NULL;

/*
3. The vendor Allenson Cycles is changing their name to Allenson Bicycles. Update it.
*/

UPDATE Purchasing.Vendor
SET Name = 'Allenson Bicycles'
WHERE Name = 'Allenson Cycles';

/*
4. We're having a one day only sale on November 1st called One Day Madness 
with a 50% discount on products to be decided later to get rid of excess inventory. 
The discount will be for direct customers with no quantity requirements. 
Add the special offer.
*/

INSERT INTO Sales.SpecialOffer (Description, DiscountPct, Type, Category, StartDate, EndDate, MinQty, MaxQty, rowguid, ModifiedDate)
VALUES ('One Day Madness', 0.50, 'Excess Inventory', 'Customer', '2019-11-01', '2019-11-02', 0, NULL, DEFAULT, GETDATE());

/*
5. Look up the SpecialOfferID you just created in 4, manually. 
We want to assign all products with a total inventory quantity 
(product is not unique in inventory) greater then 1800 to that special offer. 
Make sure to assign the product only once.
*/

INSERT INTO Sales.SpecialOfferProduct (SpecialOfferID, ProductID, rowguid, ModifiedDate)
SELECT 17, ProductID, NEWID(), GETDATE()
FROM Production.ProductInventory
GROUP BY ProductID
HAVING SUM(Quantity) > 1800;