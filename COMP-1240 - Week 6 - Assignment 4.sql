/* 
The following questions should each be answered with a single query. 
Once complete though all queries should be executable as a single script. 
Use the Keyword GO to commit the database change before using it.
All Constraints added should be named except the Not Null / Null constraint.
*/

-- 1. Create a new database for this assignment

CREATE DATABASE Assignment4;
GO

-- 2. Use the database for the rest of the SQL

USE Assignment4
GO

/* 
3. Create a table called Shipper with columns for the following data:

ShipperNumber is an integer
Company is a string with a max of 50 characters
PhoneNumber is a string
Contact is a string with a max of 100 characters
CreatedDate is a date field
*/

-- *Assumes PhoneNumber is 10 digit CA or US-style number

CREATE TABLE Shipper
(
	ShipperNumber int,
	Company varchar(50),
	PhoneNumber char(10),
	Contact varchar(100),
	CreatedDate date,
);
GO

-- 4. Change the company column to be 100 characters and not allow nulls.

ALTER TABLE Shipper
	ALTER COLUMN Company varchar(100) NOT NULL;
GO

-- 5. Change the created date to be a required field, not allow nulls, and have a default of GetDate()

/* 
*According to SQL Documentation, with 'ALTER TABLE ALTER COLUMN' to not allow NULLs, one cannot 'ADD CONSTRAINT', so this must be separated into two statements.
Source https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-table-transact-sql?view=sql-server-2017
*/

ALTER TABLE Shipper
	ALTER COLUMN CreatedDate date NOT NULL;
ALTER TABLE Shipper
	ADD CONSTRAINT DFCreatedDate
		DEFAULT (getdate())
		FOR CreatedDate;
GO

-- 6. Change the ShipperNumber to not allow nulls

ALTER TABLE Shipper
	ALTER COLUMN ShipperNumber int NOT NULL;
GO

-- 7. Change the ShipperNumber to be a Primary Key

ALTER TABLE Shipper
	ADD PRIMARY KEY(ShipperNumber);
GO

/* 
8. Create an orders table with columns for the following data:

OrderId is an integer, the primary key, and an identity field
OrderDate is a date with a default of GetDate() and does not allow nulls
ShipDate is a date
ShipperId is an integer and is a foreign key to the shipper table
CreatedDate is a date field
Freight is a decimal
CustomerId is an integer
*/

CREATE TABLE Orders
(
	OrderID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	OrderDate date NOT NULL
		CONSTRAINT DFOrderDate
			DEFAULT (getdate()),
	ShipDate date,
	ShipperID int
		CONSTRAINT FKShipperID
			FOREIGN KEY REFERENCES Shipper(ShipperNumber),
	CreatedDate date,
	Freight decimal(38,2),
	CustomerID int
);
GO

/* 
9. Create a customer table with columns for the following data:

CustomerId is an integer, Identity, and Primary Key
Company is a string with a max of 100 characters and doesn't allow nulls
PhoneNumber is a string and doesn't allow nulls
ContactName is a string with a max of 100 characters and doesn't allow nulls
*/

CREATE TABLE Customer
(
	CustomerID int IDENTITY(1,1) PRIMARY KEY,
	Company varchar(100) NOT NULL,
	PhoneNumber char(10) NOT NULL,
	ContactName varchar(100) NOT NULL
);
GO

-- 10. Alter the orders table to have a column as a foreign key to the customer table

ALTER TABLE Orders
	ADD CONSTRAINT FKCustomerID
			FOREIGN KEY (CustomerID)
			REFERENCES Customer(CustomerID);
GO

-- 11. Drop the tables in order (using 3 queries)

DROP TABLE Orders;
GO

DROP TABLE Shipper;
GO

DROP TABLE Customer;
GO

-- 12. Use the master database

USE master;
GO

-- 13. Drop the database

DROP DATABASE Assignment4;
GO