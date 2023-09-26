CREATE TABLE sales_data (
    date DATE,
    product VARCHAR(50),
    quantity_sold INT,
    revenue DECIMAL(10, 2)
    );
	select * from sales_data
	drop table sales_data
INSERT INTO sales_data (date, product, quantity_sold, revenue)
VALUES
    ('2023-09-01', 'Product A', 100, 250.00),
    ('2023-09-02', 'Product B', NULL, 75.50),
    ('2023-09-03', 'Product C', 150, NULL),
    ('2023-09-04', 'Product A', 120, 300.00),
    ('2023-09-05', 'Product B', NULL, 65.00),
    ('2023-09-06', 'Product C', 180, 450.00),
    ('2023-09-07', 'Product A', NULL, 275.00),
    ('2023-09-08', 'Product B', 90, 85.00),
    ('2023-09-09', 'Product C', 160, 410.00),
    ('2023-09-10', 'Product A', 110, NULL);
	
----Identifying the missing values

    SELECT *
    FROM sales_data
    WHERE quantity_sold IS NULL OR revenue IS NULL;
	
	
----Count Missing Values

    SELECT COUNT(quantity_sold) AS missing_column1,
    COUNT(revenue) AS missing_column2
    FROM sales_data;
	
	
----Replace Missing Values (Imputation) - Replace NULLs with 0 in quantity_sold
    
	SELECT date,product,
    COALESCE(quantity_sold, 0) AS imputed_quantity_sold,
    revenue
    FROM sales_data;
	
	
----Remove Rows with Missing Values - Remove rows with missing Quantity sold & Revenue
    
	SELECT date,
    product,
    quantity_sold,
    revenue
    FROM sales_data
    WHERE quantity_sold IS NOT NULL And revenue IS NOT NULL;
	
	
----Create Missing Value Indicator

    SELECT product, quantity_sold ,revenue,
    CASE WHEN quantity_sold IS NULL THEN 1 ELSE 0 END AS missing_quantitySold,
	CASE WHEN revenue IS NULL THEN 1 ELSE 0 END AS missing_Revenue
    FROM sales_data;

	
----Impute Missing Values with Aggregates - Replace NULLs in revenue with the average revenue
    
	SELECT date,
    product,
    quantity_sold,
    COALESCE(revenue, (SELECT Round(AVG(revenue),2) FROM sales_data)) AS imputed_revenue
    FROM sales_data;
	
	
----Impute missing values in quantity_sold column with the mean value

    UPDATE sales_data
    SET quantity_sold = (
    SELECT AVG(quantity_sold) 
    FROM sales_data 
    WHERE quantity_sold IS NOT NULL
    )
    WHERE quantity_sold IS NULL;
	
	
----Impute missing values in quantity_sold column with the median value

    UPDATE sales_data t1
    SET revenue = (
    SELECT x.revenue
    FROM sales_data x
    WHERE x.product = t1.product
    AND x.revenue IS NOT NULL
    ORDER BY x.revenue
    LIMIT 1 OFFSET (
        SELECT COUNT(*) / 2
        FROM sales_data y
        WHERE y.product = t1.product
        AND y.revenue IS NOT NULL)
        )
    WHERE revenue IS NULL;
	
	
----Impute missing values in quantity_sold column using LOCF


    UPDATE sales_data t1
SET quantity_sold = (
    SELECT x.quantity_sold
    FROM sales_data x
    WHERE x.product = t1.product
      AND x.quantity_sold IS NOT NULL
      AND x.date <= t1.date
    ORDER BY x.date DESC
    LIMIT 1
)
WHERE quantity_sold IS NULL;
	  
	 
----Impute missing values in quantity_sold column using NOCB

    UPDATE sales_data t1
    SET quantity_sold = (
    SELECT x.quantity_sold
    FROM sales_data x
    WHERE x.product = t1.product
      AND x.quantity_sold IS NOT NULL
      AND x.date >= t1.date
    ORDER BY x.date ASC
	LIMIT 1
    )
    WHERE quantity_sold IS NULL;



----Query that ignores missing values and calculates the average revenue per product

    SELECT product,
    ROUND(AVG(revenue),2) AS average_revenue
    FROM sales_data
    GROUP BY product;
	
	Select Product,sum(quantity_sold) As Total_Quantity
	from sales_data
	group by product 
	Order BY Product ASC
	
