/*
    Job de respaldo DIFFERENTIAL tres veces al dia:
    06:00, 12:00 y 18:00 hora de El Salvador (12:00, 18:00 y 00:00 UTC).
    Los diferenciales dependen del ultimo respaldo FULL. No elimine ni
    sustituya el FULL base mientras necesite esa cadena de recuperacion.
*/
USE msdb;
GO

SET NOCOUNT ON;
GO

DECLARE @JobId UNIQUEIDENTIFIER;
DECLARE @ScheduleId INT;
DECLARE @Hoy INT = CONVERT(INT, CONVERT(CHAR(8), GETDATE(), 112));
DECLARE @Comando NVARCHAR(MAX) = N'
DECLARE @Archivo NVARCHAR(500);
SET @Archivo =
    N''/var/opt/mssql/backup/differential/Biblioteca_DIFF_'' +
    CONVERT(CHAR(8), GETDATE(), 112) + N''_'' +
    REPLACE(CONVERT(CHAR(8), GETDATE(), 108), '':'', N'''') +
    N''.bak'';

BACKUP DATABASE [Biblioteca]
TO DISK = @Archivo
WITH DIFFERENTIAL, COMPRESSION, CHECKSUM, STATS = 10;
';

IF DB_ID(N'Biblioteca') IS NULL
    THROW 51000, 'No existe la base de datos Biblioteca.', 1;

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'JOB_Biblioteca_DIFFERENTIAL')
BEGIN
    EXEC msdb.dbo.sp_add_job
        @job_name = N'JOB_Biblioteca_DIFFERENTIAL',
        @enabled = 1,
        @description = N'Respaldo diferencial de Biblioteca tres veces al dia.',
        @owner_login_name = N'sa',
        @job_id = @JobId OUTPUT;

    EXEC msdb.dbo.sp_add_jobstep
        @job_id = @JobId,
        @step_name = N'Respaldo DIFFERENTIAL',
        @subsystem = N'TSQL',
        @database_name = N'master',
        @command = @Comando,
        @on_success_action = 1,
        @on_fail_action = 2;

    EXEC msdb.dbo.sp_add_jobserver @job_id = @JobId;
    PRINT N'Job JOB_Biblioteca_DIFFERENTIAL creado.';
END
ELSE
BEGIN
    SELECT @JobId = job_id
    FROM msdb.dbo.sysjobs
    WHERE name = N'JOB_Biblioteca_DIFFERENTIAL';
    PRINT N'El Job JOB_Biblioteca_DIFFERENTIAL ya existe; no se duplico ni modifico.';
END;

DECLARE @Horarios TABLE (Nombre SYSNAME, Hora INT);
INSERT INTO @Horarios (Nombre, Hora)
VALUES
    (N'SCH_Biblioteca_DIFF_0600_SV', 120000),
    (N'SCH_Biblioteca_DIFF_1200_SV', 180000),
    (N'SCH_Biblioteca_DIFF_1800_SV', 000000);

DECLARE @Nombre SYSNAME, @Hora INT;
DECLARE cur_horarios CURSOR LOCAL FAST_FORWARD FOR
    SELECT Nombre, Hora FROM @Horarios;

OPEN cur_horarios;
FETCH NEXT FROM cur_horarios INTO @Nombre, @Hora;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @ScheduleId = NULL;

    IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = @Nombre)
    BEGIN
        EXEC msdb.dbo.sp_add_schedule
            @schedule_name = @Nombre,
            @enabled = 1,
            @freq_type = 4,
            @freq_interval = 1,
            @freq_subday_type = 1,
            @active_start_date = @Hoy,
            @active_start_time = @Hora,
            @active_end_time = 235959,
            @schedule_id = @ScheduleId OUTPUT;
    END
    ELSE
    BEGIN
        SELECT @ScheduleId = schedule_id
        FROM msdb.dbo.sysschedules
        WHERE name = @Nombre;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM msdb.dbo.sysjobschedules js
        JOIN msdb.dbo.sysjobs j ON j.job_id = js.job_id
        WHERE j.name = N'JOB_Biblioteca_DIFFERENTIAL'
          AND js.schedule_id = @ScheduleId
    )
    BEGIN
        EXEC msdb.dbo.sp_attach_schedule
            @job_name = N'JOB_Biblioteca_DIFFERENTIAL',
            @schedule_id = @ScheduleId;
    END;

    FETCH NEXT FROM cur_horarios INTO @Nombre, @Hora;
END;

CLOSE cur_horarios;
DEALLOCATE cur_horarios;
GO
