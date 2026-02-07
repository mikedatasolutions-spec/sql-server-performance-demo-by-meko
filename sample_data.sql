CREATE DATABASE MekoDemoDB;
GO

USE MekoDemoDB;
GO

CREATE TABLE Sales (
    SaleID INT IDENTITY PRIMARY KEY,
    CustomerName VARCHAR(100),
    ProductName VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATETIME
);

INSERT INTO Sales (CustomerName, ProductName, Quantity, Price, SaleDate)
SELECT 
    'Customer' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR),
    'Product' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR),
    ABS(CHECKSUM(NEWID())) % 10 + 1,
    ABS(CHECKSUM(NEWID())) % 100 + 10,
    GETDATE()
FROM sys.objects;
