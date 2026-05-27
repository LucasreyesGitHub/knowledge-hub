# SQL

Notes, exercises, and certifications related to SQL and relational databases.

---

## Courses

| Course | Institución | Plataforma | Dialecto | Estado | Carpeta |
|--------|-------------|-----------|---------|--------|---------|
| SQL Analytics II (Avanzado) | Instituto CPE, Uruguay | Moodle | T-SQL / SQL Server | Completado | [sql-avanzado-moodle/](sql-avanzado-moodle/) |

---

## SQL Analytics II — Resumen de módulos

| # | Módulo | Tema principal |
|---|--------|---------------|
| I | Subqueries | IN/NOT IN, ALL/ANY, EXISTS/NOT EXISTS, scalar, correlacionadas |
| II | DDL + DML | CREATE/ALTER/DROP TABLE, SELECT INTO, INSERT, UPDATE, DELETE |
| III | Tablas Temporales | #Local, ##Global, scope y ciclo de vida |
| IV | Vistas | CREATE/ALTER/DROP VIEW, WITH SCHEMABINDING |
| V | Variables | DECLARE, SET, scope, uso en filtros dinámicos |
| VI | Stored Procedures | INPUT/OUTPUT params, @@ROWCOUNT, RETURN |
| VII | UDFs | Scalar functions, inline Table-Valued Functions (iTVF) |
| VIII | Window Functions | OVER, PARTITION BY, LAG/LEAD, RANK, DENSE_RANK, NTILE |
| IX | Performance Tips | Índices, planes de ejecución, buenas prácticas T-SQL |

→ Ver notas completas: [sql-avanzado-moodle/](sql-avanzado-moodle/)

---

## Certifications

| Certification | Issuer | Year | Credential |
|--------------|--------|------|-----------|
| SQL Analytics II | Instituto CPE, Uruguay | 2026 | — |

---

## Topics Index

| Topic | Notas | Ejercicios |
|-------|-------|-----------|
| Subqueries | [01-subqueries.md](sql-avanzado-moodle/teoria/markdown/01-subqueries.md) | [SQL](sql-avanzado-moodle/practicos/resoluciones/practico-01-subqueries-solucion.sql) |
| DDL + DML | [02-ddl-dml.md](sql-avanzado-moodle/teoria/markdown/02-ddl-dml.md) | [SQL](sql-avanzado-moodle/practicos/resoluciones/practico-02-ddl-dml-solucion.sql) |
| Tablas Temporales | [03-temp-tables.md](sql-avanzado-moodle/teoria/markdown/03-temp-tables.md) | [SQL](sql-avanzado-moodle/practicos/resoluciones/practico-03-temp-tables-solucion.sql) |
| Vistas | [04-views.md](sql-avanzado-moodle/teoria/markdown/04-views.md) | [SQL](sql-avanzado-moodle/practicos/resoluciones/practico-04-views-solucion.sql) |
| Variables | [05-variables.md](sql-avanzado-moodle/teoria/markdown/05-variables.md) | [SQL](sql-avanzado-moodle/practicos/resoluciones/practico-05-variables-solucion.sql) |
| Stored Procedures | [06-stored-procedures.md](sql-avanzado-moodle/teoria/markdown/06-stored-procedures.md) | [SQL](sql-avanzado-moodle/practicos/resoluciones/practico-06-stored-procedures-solucion.sql) |
| UDFs | [07-udfs.md](sql-avanzado-moodle/teoria/markdown/07-udfs.md) | [SQL](sql-avanzado-moodle/practicos/resoluciones/practico-07-udfs-solucion.sql) |
| Window Functions | [08-window-functions.md](sql-avanzado-moodle/teoria/markdown/08-window-functions.md) | [SQL](sql-avanzado-moodle/practicos/resoluciones/practico-08-window-functions-solucion.sql) |
| Performance Tips | [09-performance-tips.md](sql-avanzado-moodle/teoria/markdown/09-performance-tips.md) | — |

---

## Cheatsheets

| Archivo | Contenido |
|---------|-----------|
| [subqueries-cheatsheet.md](sql-avanzado-moodle/cheatsheets/subqueries-cheatsheet.md) | IN/NOT IN, EXISTS, correlated, scalar |
| [window-functions-cheatsheet.md](sql-avanzado-moodle/cheatsheets/window-functions-cheatsheet.md) | OVER, PARTITION BY, LAG/LEAD, RANK, NTILE |
| [ddl-dml-cheatsheet.md](sql-avanzado-moodle/cheatsheets/ddl-dml-cheatsheet.md) | CREATE, ALTER, DROP, INSERT, UPDATE, DELETE |
| [t-sql-vs-postgresql.md](sql-avanzado-moodle/cheatsheets/t-sql-vs-postgresql.md) | Equivalencias de sintaxis T-SQL ↔ PostgreSQL |

---

## Structure

```
sql/
├── README.md
├── sql-avanzado-moodle/     ← SQL Analytics II (CPE, 2026)
│   ├── README.md
│   ├── schema/              ← Diagrama AdventureWorks2008
│   ├── teoria/
│   │   ├── pdf/             ← PDFs originales del curso
│   │   └── markdown/        ← Notas por módulo (Módulos I–IX)
│   ├── practicos/
│   │   ├── enunciados/      ← PDFs de enunciados
│   │   ├── resoluciones/    ← Scripts SQL con soluciones (Prácticos 1–8)
│   │   └── analisis/        ← Análisis de patrones por práctico
│   ├── examen/
│   │   ├── enunciado/       ← PDF obligatorio Mayo 2026
│   │   └── resolucion/      ← Solución comentada (7 ejercicios)
│   └── cheatsheets/         ← Referencia rápida por tema
├── notes/                   ← (disponible para notas generales)
├── exercises/               ← (disponible para ejercicios adicionales)
└── certifications/          ← (disponible para certificaciones)
```
