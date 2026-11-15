/*
    Plantilla de restauracion de Biblioteca.
    IMPORTANTE:
    - No ejecutar sin reemplazar las rutas por archivos reales existentes.
    - La restauracion sobrescribe la base destino si se usa WITH REPLACE.
    - Para restaurar sobre Biblioteca, asegure que nadie la este utilizando.
    - Orden habitual: FULL -> ultimo DIFFERENTIAL compatible -> LOG en orden.
*/
USE master;
GO

/*
-- 1. Consultar los nombres logicos del respaldo FULL:
RESTORE FILELISTONLY
FROM DISK = N'/var/opt/mssql/backup/full/REEMPLAZAR_FULL.bak';
GO

-- 2. Restaurar FULL (ajuste LogicalDataName y LogicalLogName con FILELISTONLY):
RESTORE DATABASE [Biblioteca_Recuperada]
FROM DISK = N'/var/opt/mssql/backup/full/REEMPLAZAR_FULL.bak'
WITH
    MOVE N'LogicalDataName' TO N'/var/opt/mssql/data/Biblioteca_Recuperada.mdf',
    MOVE N'LogicalLogName'  TO N'/var/opt/mssql/data/Biblioteca_Recuperada_log.ldf',
    NORECOVERY,
    CHECKSUM,
    STATS = 10;
GO

-- 3. Restaurar el diferencial correspondiente al FULL anterior:
RESTORE DATABASE [Biblioteca_Recuperada]
FROM DISK = N'/var/opt/mssql/backup/differential/REEMPLAZAR_DIFF.bak'
WITH NORECOVERY, CHECKSUM, STATS = 10;
GO

-- 4. Restaurar los respaldos LOG en orden cronologico:
RESTORE LOG [Biblioteca_Recuperada]
FROM DISK = N'/var/opt/mssql/backup/log/REEMPLAZAR_LOG_1.trn'
WITH NORECOVERY, CHECKSUM, STATS = 10;
GO

-- Repetir RESTORE LOG para cada archivo siguiente, siempre en orden.

-- 5. Finalizar la recuperacion:
RESTORE DATABASE [Biblioteca_Recuperada] WITH RECOVERY;
GO
*/

/*
Verificacion de un archivo antes de restaurarlo:
RESTORE VERIFYONLY
FROM DISK = N'/ruta/al/archivo.bak'
WITH CHECKSUM;
GO

Si se desea recuperar hasta un punto en el tiempo, debe usarse STOPAT en
el ultimo RESTORE LOG y dejar la base en NORECOVERY hasta el paso final.
*/
