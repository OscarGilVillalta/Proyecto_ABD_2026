USE Biblioteca;
GO

-- ==========================================================
-- IMPORTACIÓN DE DATOS DESDE ARCHIVOS CSV
-- ==========================================================

-- ==========================================================
-- 1. EMPLEADO
-- ==========================================================
BULK INSERT rrhh.empleado
FROM '/csv/empleado.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 2. SOCIO
-- ==========================================================
BULK INSERT socios.socio
FROM '/csv/socio.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 3. LIBRO
-- ==========================================================
BULK INSERT catalogo.libro
FROM '/csv/libro.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 4. AUTOR
-- ==========================================================
BULK INSERT catalogo.autor
FROM '/csv/autor.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 5. GENERO
-- ==========================================================
BULK INSERT catalogo.genero
FROM '/csv/genero.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 6. EDITORIAL
-- ==========================================================
BULK INSERT catalogo.editorial
FROM '/csv/editorial.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 7. EJEMPLAR
-- ==========================================================
BULK INSERT catalogo.ejemplar
FROM '/csv/ejemplar.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 8. PRESTAMO
-- ==========================================================
BULK INSERT prestamos.prestamo
FROM '/csv/prestamo.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 9. MULTA
-- ==========================================================
BULK INSERT socios.multa
FROM '/csv/multa.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 10. LIBRO_AUTOR
-- ==========================================================
BULK INSERT catalogo.libro_autor
FROM '/csv/libro_autor.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 11. LIBRO_GENERO
-- ==========================================================
BULK INSERT catalogo.libro_genero
FROM '/csv/libro_genero.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 12. LIBRO_EDITORIAL
-- ==========================================================
BULK INSERT catalogo.libro_editorial
FROM '/csv/libro_editorial.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- 13. PRESTAMO_EJEMPLAR
-- ==========================================================
BULK INSERT prestamos.prestamo_ejemplar
FROM '/csv/prestamo_ejemplar.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


-- ==========================================================
-- VERIFICACIÓN DE REGISTROS IMPORTADOS
-- ==========================================================

SELECT COUNT(*) AS empleados
FROM rrhh.empleado;

SELECT COUNT(*) AS socios
FROM socios.socio;

SELECT COUNT(*) AS libros
FROM catalogo.libro;

SELECT COUNT(*) AS autores
FROM catalogo.autor;

SELECT COUNT(*) AS generos
FROM catalogo.genero;

SELECT COUNT(*) AS editoriales
FROM catalogo.editorial;

SELECT COUNT(*) AS ejemplares
FROM catalogo.ejemplar;

SELECT COUNT(*) AS prestamos
FROM prestamos.prestamo;

SELECT COUNT(*) AS multas
FROM socios.multa;

SELECT COUNT(*) AS relaciones_libro_autor
FROM catalogo.libro_autor;

SELECT COUNT(*) AS relaciones_libro_genero
FROM catalogo.libro_genero;

SELECT COUNT(*) AS relaciones_libro_editorial
FROM catalogo.libro_editorial;

SELECT COUNT(*) AS relaciones_prestamo_ejemplar
FROM prestamos.prestamo_ejemplar;
GO