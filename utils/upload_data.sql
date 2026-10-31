use Proyecto;
go

/*
    1) docker exec -u 0 -it sqlserver-2025 sh
    2) mkdir data
    3) exit
    4) cp docker cp .\data\ sqlserver-2025:\data\
*/

--! Tablas padres
IF NOT EXISTS (SELECT 1 FROM dbo.empleado)
BEGIN
    PRINT '  -> empleado';
    BULK INSERT dbo.empleado
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

IF NOT EXISTS (SELECT 1 FROM dbo.socio)
BEGIN
    PRINT '  -> socio';
    BULK INSERT dbo.socio
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

IF NOT EXISTS (SELECT 1 FROM dbo.editorial)
BEGIN
    PRINT '  -> editorial';
    BULK INSERT dbo.editorial
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

IF NOT EXISTS (SELECT 1 FROM dbo.autor)
BEGIN
    PRINT '  -> autor';
    BULK INSERT dbo.autor
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

IF NOT EXISTS (SELECT 1 FROM dbo.genero)
BEGIN
    PRINT '  -> genero';
    BULK INSERT dbo.genero
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

IF NOT EXISTS (SELECT 1 FROM dbo.libro)
BEGIN
    PRINT '  -> libro';
    BULK INSERT dbo.libro
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

IF NOT EXISTS (SELECT 1 FROM dbo.libro_autor)
BEGIN
    PRINT '  -> libro_autor';
    BULK INSERT dbo.libro_autor
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

IF NOT EXISTS (SELECT 1 FROM dbo.libro_editorial)
BEGIN
    PRINT '  -> libro_editorial';
    BULK INSERT dbo.libro_editorial
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

IF NOT EXISTS (SELECT 1 FROM dbo.libro_genero)
BEGIN
    PRINT '  -> libro_genero';
    BULK INSERT dbo.libro_genero
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

IF NOT EXISTS (SELECT 1 FROM dbo.prestamo)
BEGIN
    PRINT '  -> prestamo';
    BULK INSERT dbo.prestamo
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

IF NOT EXISTS (SELECT 1 FROM dbo.ejemplar)
BEGIN
    PRINT '  -> ejemplar';
    BULK INSERT dbo.ejemplar
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

IF NOT EXISTS (SELECT 1 FROM dbo.prestamo_ejemplar)
BEGIN
    PRINT '  -> prestamo_ejemplar';
    BULK INSERT dbo.prestamo_ejemplar
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

IF NOT EXISTS (SELECT 1 FROM dbo.multa)
BEGIN
    PRINT '  -> multa';
    BULK INSERT dbo.multa
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
SELECT 'empleado' AS tabla, COUNT(*) AS cantidad FROM dbo.empleado
UNION ALL SELECT 'socio', COUNT(*) FROM dbo.socio
UNION ALL SELECT 'editorial', COUNT(*) FROM dbo.editorial
UNION ALL SELECT 'autor', COUNT(*) FROM dbo.autor
UNION ALL SELECT 'genero', COUNT(*) FROM dbo.genero
UNION ALL SELECT 'libro', COUNT(*) FROM dbo.libro
UNION ALL SELECT 'libro_autor', COUNT(*) FROM dbo.libro_autor
UNION ALL SELECT 'libro_editorial', COUNT(*) FROM dbo.libro_editorial
UNION ALL SELECT 'libro_genero', COUNT(*) FROM dbo.libro_genero
UNION ALL SELECT 'prestamo', COUNT(*) FROM dbo.prestamo
UNION ALL SELECT 'ejemplar', COUNT(*) FROM dbo.ejemplar
UNION ALL SELECT 'prestamo_ejemplar', COUNT(*) FROM dbo.prestamo_ejemplar
UNION ALL SELECT 'multa', COUNT(*) FROM dbo.multa;
GO