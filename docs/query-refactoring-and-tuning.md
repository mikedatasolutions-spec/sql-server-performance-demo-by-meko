# Query Refactoring & Performance Tuning

## What is Query Refactoring?

Query refactoring is rewriting SQL queries to improve performance without changing the output.

## Common Problems

- Full table scans
- Non-sargable conditions:This means forces the database to scan the entire table(full Table Scan).
  Read every page to find it.That means:slow performance,high CPU usage and Poor scalability.
   Example of Non-sargable:
        SELECT *
- Nested subqueries

## Example

### Before or Non-sargable:

```sql
SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 2024;
Why?
Because the database must apply YEAR() to every row before comparing.
 ***** Sargable version:******
*****************************
SELECT * 
FROM users
WHERE created_at >= '2024-01-01'
AND created_at < '2025-01-01';

Now the index on created_at can be used.
********************************
SELECT * 
FROM customers
WHERE name LIKE '%john';
Because it starts with %, the index can’t be used efficiently.
***************************************************
Sargable:

WHERE name LIKE 'john%'


