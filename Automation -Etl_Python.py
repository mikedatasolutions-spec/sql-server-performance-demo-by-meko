import pyodbc
import pandas as pd

conn = pyodbc.connect(
    'DRIVER={SQL Server};'
    'SERVER=localhost;'
    'DATABASE=MekoDemoDB;'
    'Trusted_Connection=yes;'
)

query = "SELECT * FROM Sales"
df = pd.read_sql(query, conn)

df.to_csv("sales_report.csv", index=False)
print("Report generated successfully.")
