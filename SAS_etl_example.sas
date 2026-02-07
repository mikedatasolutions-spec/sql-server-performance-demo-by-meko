libname mekodb odbc dsn="SQLServerDSN" schema=dbo;

data sales_clean;
    set mekodb.sales;
    if quantity > 0;
run;

proc means data=sales_clean;
    var price;
run;
