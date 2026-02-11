# Index Analysis & Optimization
Meko Data Solution

This page demonstrates real-world SQL Server index analysis and optimization techniques to improve query performance for small–mid teams.
---

## 1️⃣ What is Indexing?

An **index** is a database structure that speeds up data retrieval.  
Without proper indexes, queries can result in:

- Full table scans  
- High CPU usage  
- Slow response times  

Indexes help the database quickly locate data instead of scanning entire tables.

---
## 2️⃣ Common Indexing Problems

Many slow queries are caused by:

- Missing indexes for frequently filtered columns  
- Duplicate or redundant indexes  
- Non-selective indexes (low uniqueness)  
- Unused indexes increasing write overhead  
- Incorrect index types (clustered vs non-clustered)

  ---

## 3️⃣ Index Analysis Techniques

To identify optimization opportunities:
1. **Query Execution Plans**  
   - Use `EXPLAIN` or `SET SHOWPLAN_XML ON` in SQL Server  
   - Check for table scans, missing indexes, and index seeks  

2. **Dynamic Management Views (DMVs)**  
   - Example: `sys.dm_db_missing_index_details`  
   - Identify indexes that could improve performance  

3. **Index Usage Statistics**  
   - Example: `sys.dm_db_index_usage_stats`  
   - Find unused or rarely used indexes that can be dropped  

4. **Slow Query Logs**  
   - Track queries with high duration or logical reads  
   - Check which indexes are used or missing  

---
## 4️⃣ Optimization Strategies

### 🔹 Create Missing Indexes

- Identify frequently filtered or joined columns  
- Example:

```sql
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON Orders (CustomerID);
*Result: Queries filtering by CustomerID become much faster.
Drop Unused or Redundant Indexes

Avoid indexes that are never used or overlap

Example:

DROP INDEX IX_Orders_OldIndex ON Orders;


Reduces write overhead and storage

Use Covering Indexes

Include columns in an index that satisfy the SELECT clause

Example:

CREATE NONCLUSTERED INDEX IX_Orders_CustDate
ON Orders (CustomerID, OrderDate)
INCLUDE (OrderID, TotalAmount);


Query can be satisfied entirely from the index → no table read

🔹 Clustered vs Non-Clustered Index

Clustered: Organizes the actual table data

Non-Clustered: Points to data without changing table layout

Strategy: 1 clustered per table, use non-clustered for most filters

🔹 Rebuild or Reorganize Fragmented Indexes

Fragmented indexes slow reads

Commands:

ALTER INDEX IX_Orders_CustDate ON Orders REBUILD;
ALTER INDEX IX_Orders_CustDate ON Orders REORGANIZE;


Rebuild → more resource intensive, full rebuild

Reorganize → lighter, online operation

5️⃣ Example: Before & After
🔴 Before Optimization
SELECT OrderID, CustomerID
FROM Orders
WHERE CustomerID = 12345;


Full table scan

Execution time: 2.5 sec

🟢 After Adding Index
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON Orders (CustomerID);


Index Seek instead of table scan

Execution time: 120 ms

6️⃣ Performance Benefits

Faster query execution (50–95% improvement)

Lower CPU & IO usage

Reduced table scans & locking

Efficient storage & maintenance

7️⃣ Key Takeaways

Always analyze before creating new indexes

Remove redundant or unused indexes

Use execution plans and DMVs for guidance

Optimize incrementally, test after each change

Proper indexing = foundation for all database performance tuning.
