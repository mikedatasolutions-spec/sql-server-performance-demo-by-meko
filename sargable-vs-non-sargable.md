# Impact of SARGABLE and Non-SARGABLE Queries on Database Performance

## What is SARGABLE?

**SARGABLE** (Search ARGument ABLE) queries are queries that can take advantage of indexes efficiently.

A query is sargable when the database engine can use an **Index Seek** operation instead of scanning the entire table or index. This significantly improves performance and reduces resource usage.

### ✅ Example of a Sargable Query

```sql
SELECT ID, FirstName, LastName, Hire_Date
FROM Customers
WHERE Hire_Date > '2024-01-01'
  AND Hire_Date <= '2025-02-03';
✔ This query is sargable because:

The indexed column (Hire_Date) is used directly in the WHERE clause.

No functions or calculations are applied to the indexed column.

The database can perform an Index Seek.

### What is Non-SARGABLE?
A Non-SARGABLE query prevents the database engine from using indexes efficiently.
Instead of an Index Seek, the engine performs an Index Scan or Table Scan, which negatively impacts performance.

Non-sargable queries increase:

CPU usage

I/O operations

Query execution time

 ## Common Causes of Non-SARGABLE Queries
1️⃣ Applying Functions to Indexed Columns
SELECT *
FROM Customers
WHERE YEAR(Hire_Date) = 2024;
❌ This is non-sargable because:

The YEAR() function is applied to an indexed column.

The database must evaluate the function for every row.

✔ Better approach:

WHERE Hire_Date >= '2024-01-01'
  AND Hire_Date < '2025-01-01';
##2️⃣ Using Leading Wildcards in LIKE
SELECT *
FROM Customers
WHERE FirstName LIKE '%John';
❌ The leading wildcard (%) prevents index usage.

✔ Better approach:

WHERE FirstName LIKE 'John%';
##3️⃣ Applying Calculations on Indexed Columns
SELECT FirstName, LastName, Bonus
FROM Customers
WHERE Bonus + 10 > 100;
❌ This forces the database to compute the expression for each row.

✔ Better approach:

WHERE Bonus > 90;
##4️⃣ Data Type Mismatch
If the data type in the WHERE clause does not match the column’s data type, implicit conversions may occur, preventing index usage.

Example:

WHERE NumericColumn = '100'
 ##5️⃣ Certain Operators
Operators like:

NOT

<>

IN

OR

can sometimes cause non-sargable behavior depending on the database engine and indexing strategy.

#Conclusion
✅ SARGABLE queries allow the database engine to perform Index Seek operations.

They are faster, more efficient, and use fewer system resources.

❌ Non-SARGABLE queries result in Index Scans or Table Scans, which negatively impact performance.

Writing optimized queries is essential for scalable and high-performance database systems.

