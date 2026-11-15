/*
    Job de respaldo del LOG cada 15 minutos.
    Requiere que Biblioteca use modelo de recuperacion FULL o BULK_LOGGED
    y que exista un respaldo FULL inicial para iniciar la cadena.
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
    N''/var/opt/mssql/backup/log/Biblioteca_LOG_'' +
    CONVERT(CHAR(8), GETDATE(), 112) + N''_'' +
    REPLACE(CONVERT(CHAR(8), GETDATE(), 108), '':'', N'''') +
    N''.trn'';

BACKUP LOG [Biblioteca]
TO DISK = @Archivo
WITH COMPRESSION, CHECKSUM, STATS = 10;
';

IF DB_ID(N'Biblioteca') IS NULL
    THROW 51000, 'No existe la base de datos Biblioteca.', 1;

IF NOT EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = N'Biblioteca'
      AND recovery_model_desc IN (N'FULL', N'BULK_LOGGED')
)
    THROW 51001, 'Biblioteca debe usar recovery model FULL o BULK_LOGGED.', 1;

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'JOB_Biblioteca_LOG')
BEGIN
    EXEC msdb.dbo.sp_add_job
        @job_name = N'JOB_Biblioteca_LOG',
        @enabled = 1,
        @description = N'Respaldo del log de Biblioteca cada 15 minutos.',
        @owner_login_name = N'sa',
        @job_id = @JobId OUTPUT;

    EXEC msdb.dbo.sp_add_jobstep
        @job_id = @JobId,
        @step_name = N'Respaldo LOG',
        @subsystem = N'TSQL',
        @database_name = N'master',
        @command = @Comando,
        @on_success_action = 1,
        @on_fail_action = 2;

    EXEC msdb.dbo.sp_add_jobserver @job_id = @JobId;
    PRINT N'Job JOB_Biblioteca_LOG creado.';
END
ELSE
BEGIN
    SELECT @JobId = job_id
    FROM msdb.dbo.sysjobs
    WHERE name = N'JOB_Biblioteca_LOG';
    PRINT N'El Job JOB_Biblioteca_LOG ya existe; no se duplico ni modifico.';
END;

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = N'SCH_Biblioteca_LOG_15MIN')
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name = N'SCH_Biblioteca_LOG_15MIN',
        @enabled = 1,
        @freq_type = 4,
        @freq_interval = 1,
        @freq_subday_type = 4,
        @freq_subday_interval = 15,
        @active_start_date = @Hoy,
        @active_start_time = 000500,
        @active_end_time = 235000,
        @schedule_id = @ScheduleId OUTPUT;
END
ELSE
BEGIN
    SELECT @ScheduleId = schedule_id
    FROM msdb.dbo.sysschedules
    WHERE name = N'SCH_Biblioteca_LOG_15MIN';
END;

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobschedules js
    JOIN msdb.dbo.sysjobs j ON j.job_id = js.job_id
    WHERE j.name = N'JOB_Biblioteca_LOG'
      AND js.schedule_id = @ScheduleId
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule
        @job_name = N'JOB_Biblioteca_LOG',
        @schedule_id = @ScheduleId;
END;
GO
