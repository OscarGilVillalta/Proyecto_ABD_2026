use Biblioteca;
go

create database biblioteca_prueba;
use biblioteca_prueba;

/*
    1) docker exec -u 0 -it sqlserver-2025 sh
    2) mkdir data
    3) exit
    4) cp docker cp .\data\ sqlserver-2025:\data\
*/

--! Tablas padres
use biblioteca_prueba;
IF NOT EXISTS (SELECT 1 FROM rrhh.empleado)
BEGIN
    PRINT '  -> empleado';
    BULK INSERT rrhh.empleado
    FROM '/data/data/empleado.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM socios.socio)
BEGIN
    PRINT '  -> socio';
    BULK INSERT socios.socio
    FROM '/data/data/socio.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM catalogo.editorial)
BEGIN
    PRINT '  -> editorial';
    BULK INSERT catalogo.editorial
    FROM '/data/data/editorial.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM catalogo.autor)
BEGIN
    PRINT '  -> autor';
    BULK INSERT catalogo.autor
    FROM '/data/data/autor.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM catalogo.genero)
BEGIN
    PRINT '  -> genero';
    BULK INSERT catalogo.genero
    FROM '/data/data/genero.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

--! Tablas hijas

IF NOT EXISTS (SELECT 1 FROM catalogo.libro)
BEGIN
    PRINT '  -> libro';
    BULK INSERT catalogo.libro
    FROM '/data/data/libro.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM catalogo.libro_autor)
BEGIN
    PRINT '  -> libro_autor';
    BULK INSERT catalogo.libro_autor
    FROM '/data/data/libro_autor.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM catalogo.libro_editorial)
BEGIN
    PRINT '  -> libro_editorial';
    BULK INSERT catalogo.libro_editorial
    FROM '/data/data/libro_editorial.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM catalogo.libro_genero)
BEGIN
    PRINT '  -> libro_genero';
    BULK INSERT catalogo.libro_genero
    FROM '/data/data/libro_genero.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM prestamos.prestamo)
BEGIN
    PRINT '  -> prestamo';
    BULK INSERT prestamos.prestamo
    FROM '/data/data/prestamo.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM catalogo.ejemplar)
BEGIN
    PRINT '  -> ejemplar';
    BULK INSERT catalogo.ejemplar
    FROM '/data/data/ejemplar.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM prestamos.prestamo_ejemplar)
BEGIN
    PRINT '  -> prestamo_ejemplar';
    BULK INSERT prestamos.prestamo_ejemplar
    FROM '/data/data/prestamo_ejemplar.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

IF NOT EXISTS (SELECT 1 FROM socios.multa)
BEGIN
    PRINT '  -> multa';
    BULK INSERT socios.multa
    FROM '/data/data/multa.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        KEEPIDENTITY,
        TABLOCK
    );
END;

--! Verificar datos cargados
SELECT 'empleado' AS tabla, COUNT(*) AS cantidad FROM rrhh.empleado
UNION ALL SELECT 'socio', COUNT(*) FROM socios.socio
UNION ALL SELECT 'editorial', COUNT(*) FROM catalogo.editorial
UNION ALL SELECT 'autor', COUNT(*) FROM catalogo.autor
UNION ALL SELECT 'genero', COUNT(*) FROM catalogo.genero
UNION ALL SELECT 'libro', COUNT(*) FROM catalogo.libro
UNION ALL SELECT 'libro_autor', COUNT(*) FROM catalogo.libro_autor
UNION ALL SELECT 'libro_editorial', COUNT(*) FROM catalogo.libro_editorial
UNION ALL SELECT 'libro_genero', COUNT(*) FROM catalogo.libro_genero
UNION ALL SELECT 'prestamo', COUNT(*) FROM prestamos.prestamo
UNION ALL SELECT 'ejemplar', COUNT(*) FROM catalogo.ejemplar
UNION ALL SELECT 'prestamo_ejemplar', COUNT(*) FROM prestamos.prestamo_ejemplar
UNION ALL SELECT 'multa', COUNT(*) FROM socios.multa;
GO