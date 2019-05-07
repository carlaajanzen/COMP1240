/* Assignment
Attached you'll find a database of books for a library.
The data is in a single sheet.
You are to create a normalized database to practical business standard levels.
*/

-- 1. Provide what level you are normalizing to.

-- 2. Provide the text description of the business rules for how the entities you create relate

/* 3. Provide an ERD for the database showing the relationships. 
The type of ERD doesn't matter, as long as I can clearly see the Primary Keys, Foreign Keys, and the Many side of the relationships. 
If you use SQL Servers diagramming tool then I suggest using a print screen and pasting that into a document.
*/

/* Submissions
As this submission has no SQL code a document would server better. Also acceptable is MS Word, PDF, or Text.
*/

-- Create the Database LibraryBooks
CREATE DATABASE LibraryBooks;
GO

-- Use the database for the assignment
USE LibraryBooks;
GO

-- Create BookHeader Table (Necessary for 1NF)

CREATE TABLE BookHeader
(
	BookID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Title nvarchar(255) NOT NULL,
	AuthorName nvarchar(50) NOT NULL
);
GO

-- Create BookDetail Table (necessary for 3NF)

CREATE TABLE BookDetail
(
	BookID int NOT NULL
		CONSTRAINT FKBookID
			FOREIGN KEY REFERENCES BookHeader(BookID),
	PublisherID int IDENTITY(1,1) NOT NULL,
	PublishDate date NOT NULL,
	MSRP money NOT NULL,
	ISBN10 nchar(13) NOT NULL,
	ISBN13 nchar(17) NOT NULL,
	Length int NOT NULL,
	PRIMARY KEY (BookID, PublisherID)
);
GO

-- Create PostalZipHeader Table (Necessary for 3NF)

CREATE TABLE PostalZipHeader
(
	PostalZip varchar(10) NOT NULL PRIMARY KEY,
	City varchar(50) NOT NULL,
	Region varchar(50) NOT NULL,
);
GO

-- Create PublisherHeader Table (Necessary for 2NF)

CREATE TABLE PublisherHeader
(
	PublisherID int NOT NULL,
	Publisher nvarchar(255) NOT NULL,
	Street varchar(255) NOT NULL,
	PostalZip varchar(10) NOT NULL
		CONSTRAINT FKPostalZip
			REFERENCES PostalZipHeader(PostalZip)
	PRIMARY KEY (PublisherID)
);
GO

-- Add Foreign Key to create a relationship with PublisherID
ALTER TABLE PublisherHeader
	ADD CONSTRAINT FKPublisherID
		FOREIGN KEY (PublisherID)
		REFERENCES BookDetail(PublisherID);
GO

-- Create CategoryDetail Table (Necessary for 2NF)
CREATE TABLE CategoryDetail
(
	BookID int NOT NULL
		CONSTRAINT FKBookIDCategory
			REFERENCES BookHeader(BookID),
	Category varchar(50) NOT NULL,
	PRIMARY KEY(BookID, Category)
);

-- Create InventoryDetail Table (Optional for 3NF)
CREATE TABLE InventoryDetail
(
	BookID int NOT NULL
		CONSTRAINT FKBookIDInventory
			REFERENCES BookHeader(BookID),
	PublisherID int NOT NULL,
	CopiesAvailable int NOT NULL,
	CopiesOnLoan int NOT NULL,
	DeweyDecimal varchar(3) NOT NULL
	PRIMARY KEY (BookID, PublisherID)
);
GO

-- Add foreign key constraint to link PublisherID
ALTER TABLE InventoryDetail
	ADD CONSTRAINT FKPublisherIDInventory
		FOREIGN KEY (BookID, PublisherID)
		REFERENCES BookDetail(BookID, PublisherID);
GO