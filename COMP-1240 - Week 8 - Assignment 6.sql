-- Assignment 6 - Indexes

-- We want to improve the speed of looking for certain transaction types on the transaction history table.

USE AdventureWorks2016;
GO

-- 1. Create an index following naming conventions on the transaction type column. It is used in ascending order.

CREATE INDEX IX_TransactionHistory_TransactionType
ON Production.TransactionHistory(TransactionType ASC)
GO

-- 2. Alter the index to have a fill factor of 80. We opt for not keeping the index online, we want full optimization.

ALTER INDEX IX_TransactionHistory_TransactionType
ON Production.TransactionHistory
	REBUILD WITH (FILLFACTOR = 80);
GO

-- 3. We are actually only looking at transactions of type 'W', add a filter to the index.

-- Adding the WHERE Filter must be done when the index is created, therefore the existing index is dropped and recreated with the WHERE filter
DROP INDEX IX_TransactionHistory_TransactionType
ON Production.TransactionHistory

CREATE INDEX IX_TransactionHistory_TransactionType
ON Production.TransactionHistory(TransactionType ASC)
	WHERE TransactionType = 'W'
	WITH FIllFACTOR = 80;
GO

-- 4. Drop the index

DROP INDEX IX_TransactionHistory_TransactionType
ON Production.TransactionHistory;
GO