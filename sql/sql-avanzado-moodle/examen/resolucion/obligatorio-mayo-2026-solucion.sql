-- =============================================================
-- SQL Analytics II — Instituto CPE, Uruguay
-- EXAMEN OBLIGATORIO — Mayo 2026
-- 7 ejercicios / 100 puntos
-- Base de datos: AdventureWorks2008 (T-SQL / SQL Server)
-- =============================================================

USE AdventureWorks2008;
GO

-- =============================================================
-- EJERCICIO 1 — 10 puntos
-- Tabla temporal #Vtas_Producto_Año
-- Campos: ProductID, NombreProducto, AñoFacturación, PrecioUnitario,
--         SumaUnidades, TotalVentas (SumaUnidades * PrecioUnitario)
-- Patrón: SELECT INTO con GROUP BY sobre SalesOrderDetail + SalesOrderHeader + Product
-- Nota: MAX(UnitPrice) porque el precio puede variar entre órdenes del mismo año.
-- =============================================================
SELECT
    p.ProductID,
    p.Name                                            AS NombreProducto,
    YEAR(soh.OrderDate)                               AS AñoFacturacion,
    MAX(sod.UnitPrice)                                AS PrecioUnitario,
    SUM(sod.OrderQty)                                 AS SumaUnidades,
    SUM(sod.OrderQty * sod.UnitPrice)                 AS TotalVentas
INTO #Vtas_Producto_Año
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY p.ProductID, p.Name, YEAR(soh.OrderDate);

-- Verificación
SELECT TOP 10 * FROM #Vtas_Producto_Año ORDER BY AñoFacturacion, TotalVentas DESC;
GO


-- =============================================================
-- EJERCICIO 2 — 15 puntos
-- UDF escalar dbo.Variacion_Porc(A, B) → (A/B) - 1 en porcentaje
-- Reglas:
--   a) Si B = 0 → devolver '0.00%' (no dividir)
--   b) Formato: porcentaje con 2 decimales (FORMAT 'P2')
--   c) Acepta enteros y decimales (MONEY cubre ambos)
-- =============================================================
CREATE FUNCTION dbo.Variacion_Porc (
    @ValorA MONEY,
    @ValorB MONEY
)
RETURNS VARCHAR(20)
AS
BEGIN
    IF @ValorB = 0
        RETURN '0.00%';
    RETURN FORMAT((@ValorA / @ValorB) - 1, 'P2');
END;
GO

-- Test: al menos 5 llamadas
SELECT dbo.Variacion_Porc(3,   2)    AS [Ej_50pct];       -- 50.00%
SELECT dbo.Variacion_Porc(1.5, 2)    AS [Ej_menos25pct];  -- -25.00%
SELECT dbo.Variacion_Porc(100, 0)    AS [DivCero];        -- 0.00%
SELECT dbo.Variacion_Porc(0,   100)  AS [Ej_0];           -- -100.00%
SELECT dbo.Variacion_Porc(120, 100)  AS [Ej_20pct];       -- 20.00%
GO


-- =============================================================
-- EJERCICIO 3 — 10 puntos
-- Vista dbo.VariacionPrecioCosto usando dbo.Variacion_Porc
-- Campos: ProductID, Nombre, PrecioLista, CostoEstandar, Variacion, Categoria
-- Luego filtrar por Categoria = 'Accessories'
-- =============================================================
CREATE VIEW dbo.VariacionPrecioCosto
AS
SELECT
    p.ProductID,
    p.Name                                             AS Nombre,
    p.ListPrice                                        AS PrecioLista,
    p.StandardCost                                     AS CostoEstandar,
    dbo.Variacion_Porc(p.ListPrice, p.StandardCost)    AS Variacion,
    pc.Name                                            AS Categoria
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory    pc ON ps.ProductCategoryID   = pc.ProductCategoryID;
GO

-- Consulta: solo Accessories
SELECT ProductID, Nombre, PrecioLista, CostoEstandar, Variacion
FROM dbo.VariacionPrecioCosto
WHERE Categoria = 'Accessories'
ORDER BY PrecioLista DESC;
GO


-- =============================================================
-- EJERCICIO 4 — 20 puntos
-- SP dbo.QtyEmp_Vacation_Hours
-- INPUT:  @JobTitle NVARCHAR(50), @FechaDesde DATE, @FechaHasta DATE
-- OUTPUT: @CantEmpleados INT, @TotalVacationHours INT
-- =============================================================
CREATE PROCEDURE dbo.QtyEmp_Vacation_Hours
    @JobTitle           NVARCHAR(50),
    @FechaDesde         DATE,
    @FechaHasta         DATE,
    @CantEmpleados      INT OUTPUT,
    @TotalVacationHours INT OUTPUT
AS
SET NOCOUNT ON;
SELECT
    @CantEmpleados      = COUNT(BusinessEntityID),
    @TotalVacationHours = SUM(VacationHours)
FROM HumanResources.Employee
WHERE JobTitle   = @JobTitle
  AND HireDate BETWEEN @FechaDesde AND @FechaHasta;
GO

-- Ejecución con los valores del examen:
-- JobTitle = 'Marketing Specialist', Desde 01/01/1999, Hasta 01/01/2000
DECLARE @Cant INT, @Vacaciones INT;
EXEC dbo.QtyEmp_Vacation_Hours
    'Marketing Specialist',
    '1999-01-01',
    '2000-01-01',
    @Cant OUTPUT,
    @Vacaciones OUTPUT;
SELECT @Cant AS CantidadEmpleados, @Vacaciones AS TotalHorasVacacion;
GO


-- =============================================================
-- EJERCICIO 5 — 10 puntos
-- Para cada factura: CustomerID, nombre completo concatenado,
-- SalesOrderID, AñoFactura, TotalDue, TotalAnualCliente (subquery).
-- Ordenar por CustomerID ASC.
-- =============================================================
SELECT
    soh.CustomerID,
    p.FirstName + ' ' + p.LastName                   AS NombreCompleto,
    soh.SalesOrderID,
    YEAR(soh.OrderDate)                               AS AñoFactura,
    soh.TotalDue,
    (SELECT SUM(soh2.TotalDue)
     FROM Sales.SalesOrderHeader soh2
     WHERE soh2.CustomerID       = soh.CustomerID
       AND YEAR(soh2.OrderDate)  = YEAR(soh.OrderDate)
    )                                                 AS TotalAnualCliente
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer  c ON soh.CustomerID  = c.CustomerID
JOIN Person.Person   p ON c.PersonID      = p.BusinessEntityID
ORDER BY soh.CustomerID ASC;


-- =============================================================
-- EJERCICIO 6 — 15 puntos
-- Mismo resultado que Ejercicio 5, reemplazando la subquery por OVER.
-- Ventaja: una sola pasada sobre los datos (vs N ejecuciones por fila).
-- =============================================================
SELECT
    soh.CustomerID,
    p.FirstName + ' ' + p.LastName                   AS NombreCompleto,
    soh.SalesOrderID,
    YEAR(soh.OrderDate)                               AS AñoFactura,
    soh.TotalDue,
    SUM(soh.TotalDue) OVER (
        PARTITION BY soh.CustomerID, YEAR(soh.OrderDate)
    )                                                 AS TotalAnualCliente
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer  c ON soh.CustomerID  = c.CustomerID
JOIN Person.Person   p ON c.PersonID      = p.BusinessEntityID
ORDER BY soh.CustomerID ASC;


-- =============================================================
-- EJERCICIO 7 — 20 puntos
-- Para cada compra: CustomerID, FirstName, LastName, SalesOrderID,
-- OrderDate, Previous_Order_Date, Inactive_Days.
-- Primera compra de cada cliente → Previous_Order_Date = NULL, Inactive_Days = NULL.
-- Patrón: LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)
-- =============================================================
SELECT
    soh.CustomerID,
    p.FirstName,
    p.LastName,
    soh.SalesOrderID,
    soh.OrderDate,
    LAG(soh.OrderDate) OVER (
        PARTITION BY soh.CustomerID
        ORDER BY soh.OrderDate
    )                                                 AS Previous_Order_Date,
    DATEDIFF(DAY,
        LAG(soh.OrderDate) OVER (
            PARTITION BY soh.CustomerID
            ORDER BY soh.OrderDate
        ),
        soh.OrderDate
    )                                                 AS Inactive_Days
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer  c ON soh.CustomerID  = c.CustomerID
JOIN Person.Person   p ON c.PersonID      = p.BusinessEntityID
ORDER BY soh.CustomerID, soh.OrderDate;

-- =============================================================
-- FIN DEL EXAMEN — Integración de módulos
--   Ex1: SELECT INTO (Módulo III — Tablas Temporales)
--   Ex2: UDF escalar con control de división por cero (Módulo VII)
--   Ex3: Vista que consume UDF (Módulo IV)
--   Ex4: SP con parámetros OUTPUT (Módulo VI)
--   Ex5: Subquery correlacionada en SELECT (Módulo I)
--   Ex6: OVER como alternativa a subquery (Módulo VIII)
--   Ex7: LAG para análisis temporal entre compras (Módulo VIII)
-- =============================================================
