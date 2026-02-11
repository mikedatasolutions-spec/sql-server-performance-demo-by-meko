# Query Refactoring & Performance Tuning
Meko Data Solution

This page demonstrates real-world SQL Server query refactoring techniques to improve database performance for small–mid teams.

---

## 1️⃣ What is Query Refactoring?

Query refactoring is the process of **rewriting SQL queries to improve performance** without changing the results.

Goals:
- Reduce execution time  
- Minimize CPU and I/O usage  
- Improve scalability  
- Avoid unnecessary operations  

---

## 2️⃣ Common Causes of Slow Queries

- Full table scans  
- Functions in WHERE clauses (non-sargable queries)  
- SELECT * instead of specific columns  
- Nested subqueries or inefficient JOINs  
- Missing or poorly designed indexes  
- Large result sets without filtering  

---

## 3️⃣ Case Study Example

### 🔴 Before Refactoring

```sql
SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 2024;
Problems:

Function in WHERE prevents index usage

Full table scan

High I/O and slow execution

Execution time: 3.8 seconds

🟢 After Refactoring
SELECT OrderID, CustomerID, OrderDate
FROM Orders
WHERE OrderDate >= '2024-01-01'
  AND OrderDate < '2025-01-01';
Improvements:

Removed function in WHERE

Allowed index seek

Reduced CPU and I/O

Execution time: 320 ms

4️⃣ Refactoring Techniques
Remove non-sargable conditions

Select only required columns (SELECT column1, column2)

Convert subqueries to JOINs when possible

Filter early to reduce data processed

Use EXISTS instead of IN for better performance

Avoid functions in WHERE clauses that prevent index usage

5️⃣ Measuring Impact
Compare execution plans before and after refactoring

Track logical reads, CPU, and duration

Show actual improvement in performance metrics

6️⃣ Key Takeaways
Query refactoring is the first step to better database performance

Always test after each change

Use execution plans to validate improvements

Small changes can lead to big performance gains

