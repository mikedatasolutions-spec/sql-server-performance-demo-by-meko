# Understanding Indexing in SQL Server

## What Is an Index?

An **index** is a database object that improves the speed of data retrieval operations.

Think of it like the index at the back of a book.  
Instead of reading every page to find a topic, you look at the index and jump directly to the page number.

Similarly, a database index allows SQL Server to quickly locate rows without scanning the entire table.

Without an index:
- The database performs a **Table Scan**

With an index:
- The database performs an **Index Seek**

---

## How Does an Index Work?

Most relational databases (SQL Server, MySQL, PostgreSQL) use a **B-Tree structure** for indexes.

Structure:

Root Page
↓
Intermediate Pages
↓
Leaf Pages


- **Root Page**: Starting point of the index  
- **Intermediate Pages**: Navigation levels  
- **Leaf Pages**: Contain actual data or pointers to the data  

This structure allows fast searching using logarithmic time complexity.

---

## What Is a Page?

A **page** is the smallest unit of data storage in SQL Server.

- Page size = **8 KB**  
- Tables are stored in pages  
- Indexes are stored in pages  

Everything in SQL Server is stored inside pages.

---

## Clustered vs Non-Clustered Index

### Clustered Index
- Determines the **physical order** of table data  
- Only **one clustered index per table**  
- Table data is stored at the leaf level  

```sql
CREATE CLUSTERED INDEX IX_Customers_ID
ON Customers(ID);
=============================================
Non-Clustered Index
==================================================
Separate structure from table data

Contains the indexed column(s) and a pointer to the row

You can create multiple non-clustered indexes

CREATE NONCLUSTERED INDEX IX_Customers_HireDate
ON Customers(Hire_Date);
==================================================
How Do We Use Indexes?
Indexes improve performance for:

SELECT

WHERE

JOIN

ORDER BY

GROUP BY

Example:

SELECT *
FROM Customers
WHERE Hire_Date = '2024-01-01';
Indexed column → Index Seek

Non-indexed column → Table Scan

Index Fragmentation
=============================================
Index fragmentation occurs when the logical order of pages does not match the physical order.

Types of Fragmentation
==============================================
## Internal Fragmentation:

Pages are not fully filled

Wasted space inside pages

##External Fragmentation:

Pages are out of order on disk

Slower range scans

Fragmentation usually happens due to:

INSERT

UPDATE

DELETE

Page splits (common with random keys like GUIDs)
=============================================
Page Splits
When a page becomes full:

SQL Server creates a new page

Moves half the rows to the new page

Updates index pointers

This causes:

Fragmentation

Extra I/O

Performance overhead


================================================
Key Difference:

Fragmentation is the problem (disorder of pages)

Rebuild/Reorganize is the solution (fixes fragmentation)
========================================================
How to Check Index Fragmentation

Use sys.dm_db_index_physical_stats in SQL Server:

SELECT
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i
ON ips.object_id = i.object_id
AND ips.index_id = i.index_id
WHERE ips.avg_fragmentation_in_percent > 5
ORDER BY ips.avg_fragmentation_in_percent DESC;
===============================================
< 5% → No action needed

5–30% → Consider REORGANIZE

> 30% → Consider REBUILD
===============================================
When Should You Create an Index?
Create an index when:

A column is frequently used in WHERE

A column is used in JOIN

A column is used in ORDER BY

A column has high selectivity (many unique values)

Avoid creating indexes when:

The table is very small

Column has low selectivity (e.g., Gender)

Column is frequently updated

Too many indexes exist
=========================================================
Important Trade-Offs
Indexes:

✅ Improve SELECT performance
❌ Slow down INSERT, UPDATE, DELETE
❌ Consume additional disk space

Because every time data changes, related indexes must also update.
==================================================================
Summary
Concept	Description
Index	  :       Improves data retrieval speed
Clustered Index	:  Controls physical data order
Non-Clustered Index :	Separate structure with pointer to data
Page	 : 8 KB storage unit
Fragmentation : Logical order differs from physical order
Rebuild	:       Recreates index completely
Reorganize	:   Light defragmentation
Check Fragmentation :  	sys.dm_db_index_physical_stats
=================================================================
Final Thought
Proper indexing is one of the most important factors in database performance tuning.
Understanding fragmentation and knowing when to rebuild or reorganize indexes ensures high-performance, scalable database systems.
