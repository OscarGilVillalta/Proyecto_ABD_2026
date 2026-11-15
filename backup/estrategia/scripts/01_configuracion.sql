/*
    Biblioteca - Configuracion de directorios de respaldo
    SQL Server 2025 / SQL Server Agent

    Ejecutar como sysadmin.
    Los directorios deben existir y ser accesibles por la cuenta del servicio
    de SQL Server. Este script intenta crearlos con xp_create_subdir.
*/
USE master;
GO

SET NOCOUNT ON;
GO

DECLARE @Rutas TABLE (Ruta NVARCHAR(4000));
INSERT INTO @Rutas (Ruta)
VALUES
    (N'/var/opt/mssql/backup'),
    (N'/var/opt/mssql/backup/full'),
    (N'/var/opt/mssql/backup/differential'),
    (N'/var/opt/mssql/backup/log');

DECLARE @Ruta NVARCHAR(4000);
DECLARE @Resultado TABLE (FileExists INT, FileIsDirectory INT, ParentDirectoryExists INT);

DECLARE cur_rutas CURSOR LOCAL FAST_FORWARD FOR
    SELECT Ruta FROM @Rutas;

OPEN cur_rutas;
FETCH NEXT FROM cur_rutas INTO @Ruta;

WHILE @@FETCH_STATUS = 0
BEGIN
    DELETE FROM @Resultado;
    INSERT INTO @Resultado
    EXEC master.dbo.xp_fileexist @Ruta;

    IF EXISTS (SELECT 1 FROM @Resultado WHERE FileIsDirectory = 1)
    BEGIN
        PRINT N'Existe: ' + @Ruta;
    END
    ELSE
    BEGIN
        BEGIN TRY
            EXEC master.dbo.xp_create_subdir @Ruta;
            PRINT N'Se solicito crear: ' + @Ruta;
        END TRY
        BEGIN CATCH
            PRINT N'No se pudo crear ' + @Ruta + N'. Verifique permisos y cree la carpeta manualmente.';
            PRINT ERROR_MESSAGE();
        END CATCH;
    END;

    FETCH NEXT FROM cur_rutas INTO @Ruta;
END;

CLOSE cur_rutas;
DEALLOCATE cur_rutas;
GO

/*
    Compruebe que la cuenta del servicio SQL Server tenga permisos de
    escritura en las cuatro rutas antes de ejecutar los Jobs.
*/
