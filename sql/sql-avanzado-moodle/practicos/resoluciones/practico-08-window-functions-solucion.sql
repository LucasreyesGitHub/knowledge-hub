-- =============================================================
-- SQL Analytics II — Instituto CPE, Uruguay
-- Práctico 8 — Window Functions (Tracking Analytics)
-- Base de datos: AdventureWorks2008 (T-SQL / SQL Server)
-- =============================================================

USE AdventureWorks2008;
GO

-- -------------------------------------------------------------
-- Ejercicio 1
-- Para las órdenes 43659, 43664 y 54490: mostrar id de orden,
-- id de producto, cantidad de unidades, total de unidades por orden
-- y porcentaje de cada línea respecto al total de unidades de la orden.
-- Patrón: SUM(OrderQty) OVER (PARTITION BY SalesOrderID)
-- -------------------------------------------------------------
SELECT
    sod.SalesOrderID,
    sod.ProductID,
    sod.OrderQty,
    SUM(sod.OrderQty) OVER (PARTITION BY sod.SalesOrderID)     AS Total,
    FORMAT(
        CAST(sod.OrderQty AS FLOAT) /
        SUM(sod.OrderQty) OVER (PARTITION BY sod.SalesOrderID),
        'P2'
    )                                                           AS [Percent by ProductID]
FROM Sales.SalesOrderDetail sod
WHERE sod.SalesOrderID IN (43659, 43664, 54490)
ORDER BY sod.SalesOrderID, sod.SalesOrderDetailID;


-- -------------------------------------------------------------
-- Ejercicio 2
-- Producto más vendido (mayor cantidad de órdenes) por subcategoría.
-- Patrón: RANK() OVER (PARTITION BY subcategoria ORDER BY COUNT DESC)
--         + subquery exterior para filtrar Ranking = 1
-- Nota: "más vendido" = aparece en mayor cantidad de órdenes distintas
-- -------------------------------------------------------------
SELECT subcategory_name, product_name, ranking
FROM (
    SELECT
        ps.Name                                AS subcategory_name,
        p.Name                                 AS product_name,
        COUNT(DISTINCT sod.SalesOrderID)       AS TotalOrdenes,
        RANK() OVER (
            PARTITION BY ps.ProductSubcategoryID
            ORDER BY COUNT(DISTINCT sod.SalesOrderID) DESC
        )                                      AS ranking
    FROM Production.Product p
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Sales.SalesOrderDetail sod          ON p.ProductID = sod.ProductID
    GROUP BY ps.ProductSubcategoryID, ps.Name, p.ProductID, p.Name
) AS ranked
WHERE ranking = 1
ORDER BY subcategory_name;


-- -------------------------------------------------------------
-- Ejercicio 3
-- Total de ventas por año y territorio, y porcentaje sobre el total
-- de ventas de ese mismo año.
-- Patrón: SUM(SUM()) OVER (PARTITION BY año) — doble SUM
-- -------------------------------------------------------------
SELECT
    YEAR(soh.OrderDate)                                     AS Año,
    soh.TerritoryID,
    SUM(soh.TotalDue)                                       AS TotalVentas,
    FORMAT(
        SUM(soh.TotalDue) /
        SUM(SUM(soh.TotalDue)) OVER (PARTITION BY YEAR(soh.OrderDate)),
        'P2'
    )                                                       AS PorcentajeDelTotalAnual
FROM Sales.SalesOrderHeader soh
GROUP BY YEAR(soh.OrderDate), soh.TerritoryID
ORDER BY Año, soh.TerritoryID;


-- -------------------------------------------------------------
-- Ejercicio 4
-- Ventas por año-mes en un campo, ventas del mes anterior y variación.
-- Patrón: LAG(SUM()) OVER (ORDER BY año, mes) sobre GROUP BY
-- MesAño se expresa como YYYYMM (ej: 200107 = julio 2001)
-- -------------------------------------------------------------
SELECT
    CAST(YEAR(OrderDate) AS VARCHAR(4)) +
    RIGHT('0' + CAST(MONTH(OrderDate) AS VARCHAR(2)), 2)    AS MesAño,
    SUM(TotalDue)                                           AS TotalVentas,
    LAG(SUM(TotalDue)) OVER (
        ORDER BY YEAR(OrderDate), MONTH(OrderDate)
    )                                                       AS TotalVentasMesAnterior,
    SUM(TotalDue) - LAG(SUM(TotalDue)) OVER (
        ORDER BY YEAR(OrderDate), MONTH(OrderDate)
    )                                                       AS Variacion
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate), MONTH(OrderDate);
