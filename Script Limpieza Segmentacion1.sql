create database segmentacion;
use segmentacion;

# Crear tabla para importar datos
CREATE TABLE temp_online_retail (
    InvoiceNo VARCHAR(50),
    StockCode VARCHAR(50),
    Description VARCHAR(255),
    Quantity VARCHAR(50),
    InvoiceDate VARCHAR(50),
    UnitPrice VARCHAR(50),
    CustomerID VARCHAR(50),
    Country VARCHAR(100)
);

SET GLOBAL local_infile = 1;

#Importamos base de datos
LOAD DATA LOCAL INFILE 'C:/Users/luism/Downloads/Online_Retail_comma.csv'
INTO TABLE temp_online_retail
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

describe temp_online_retail;

#Revisamos columnas para detectar valores inconsistentes o nulos
select * from temp_online_retail;
select distinct InvoiceNo from temp_online_retail;
select distinct Quantity from temp_online_retail;
select distinct UnitPrice from temp_online_retail;
select distinct CustomerID from temp_online_retail;

#Filtramos columnas con cantidades negativas
select InvoiceNo, Quantity from temp_online_retail where Quantity < 0;

#Creamos nueva tabla con la misma estructura para modificar los datos y realizar la limpieza, sin cambiar datos originales
CREATE TABLE copia_online_retail LIKE temp_online_retail;

#Copiamos los datos originales a la nueva tabla 
INSERT INTO copia_online_retail
SELECT * FROM temp_online_retail;

#Filtramos las facturas con sus respectivas notas de crédito (InvoiceNo con C)
SELECT *
FROM copia_online_retail
WHERE RIGHT(InvoiceNo, LENGTH(InvoiceNo) - 1) NOT IN (
    SELECT 
        CASE
            WHEN InvoiceNo LIKE 'C%' THEN RIGHT(InvoiceNo, LENGTH(InvoiceNo) - 1)
            ELSE InvoiceNo
        END AS Invoice
    FROM copia_online_retail
    GROUP BY InvoiceNo
    HAVING COUNT(*) > 1
)
AND InvoiceNo NOT LIKE 'C%';

#Eliminamos notas de crédito y sus facturas relacionadas
DELETE FROM copia_online_retail
WHERE InvoiceNo IN (
    SELECT InvoiceNo FROM (
        SELECT DISTINCT 
            original.InvoiceNo
        FROM copia_online_retail original
        JOIN copia_online_retail devolucion
            ON devolucion.InvoiceNo = CONCAT('C', original.InvoiceNo)

        UNION

        SELECT DISTINCT InvoiceNo
        FROM copia_online_retail
        WHERE InvoiceNo LIKE 'C%'
    ) AS sub1
);

#Eliminamos cualquier nota de crédito huérfana que no se haya eliminado antes
DELETE FROM copia_online_retail
WHERE Quantity < 0;

#Revisamos que ya no existan facturas con valores negativos o devoluciones
SELECT * 
FROM copia_online_retail
WHERE InvoiceNo LIKE 'C%' OR Quantity < 0;

#Filtramos los precios negativos que observamos antes
select * from copia_online_retail where UnitPrice < 0;
select * from copia_online_retail where InvoiceNo in ('A563185', 'A563186', 'A563187');

#Eliminamos las facturas con precios en negativo
DELETE FROM copia_online_retail
WHERE InvoiceNo IN ('A563185', 'A563186', 'A563187');

#Revisamos posibles valores en blanco o nulos en CustomerID, UnitPrice y Quantity
SELECT *
FROM copia_online_retail
WHERE CustomerID IS NULL 
   OR CustomerID = '' 
   OR UPPER(TRIM(CustomerID)) = 'NA';
   
SELECT *
FROM copia_online_retail
WHERE UnitPrice IS NULL 
   OR TRIM(UnitPrice) = '' 
   OR UPPER(TRIM(UnitPrice)) = 'NA'
   OR (
       REPLACE(UnitPrice, ',', '.') REGEXP '^[0-9]+(\\.[0-9]+)?$'  -- solo valores numéricos válidos
       AND CAST(REPLACE(UnitPrice, ',', '.') AS DECIMAL(10,2)) = 0
   );

SELECT *
FROM copia_online_retail
WHERE Quantity IS NULL 
   OR TRIM(Quantity) = '' 
   OR UPPER(TRIM(Quantity)) = 'NA'
   OR (
       REPLACE(Quantity, ',', '.') REGEXP '^[0-9]+(\\.[0-9]+)?$'  -- solo valores numéricos válidos
       AND CAST(REPLACE(Quantity, ',', '.') AS DECIMAL(10,2)) = 0
   );

#Eliminamos las facturas con CustomerID y UnitPrice vacío o nulo
DELETE FROM copia_online_retail
WHERE CustomerID IS NULL 
   OR CustomerID = '' 
   OR UPPER(TRIM(CustomerID)) = 'NA';
   
DELETE FROM copia_online_retail
WHERE UnitPrice IS NULL 
   OR TRIM(UnitPrice) = '' 
   OR UPPER(TRIM(UnitPrice)) = 'NA'
   OR (
       REPLACE(UnitPrice, ',', '.') REGEXP '^[0-9]+(\\.[0-9]+)?$'  -- solo valores numéricos válidos
       AND CAST(REPLACE(UnitPrice, ',', '.') AS DECIMAL(10,2)) = 0
   );

#Damos formato de fecha a InvoiceDate
ALTER TABLE copia_online_retail MODIFY COLUMN InvoiceDateDate DATE;
UPDATE copia_online_retail
SET InvoiceDateDate = STR_TO_DATE(InvoiceDate, '%d/%m/%Y %H:%i');

#Exportamos la base de datos limpia a un archivo csv para continuar con el siguiente paso
(SELECT 'InvoiceNo', 'StockCode', 'Description', 'Quantity', 'InvoiceDate', 'UnitPrice', 'CustomerID', 'Country')
UNION ALL
(SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    REPLACE(UnitPrice, ',', '.') AS UnitPrice,
    CustomerID,
    Country
FROM copia_online_retail)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retail_clean.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';


