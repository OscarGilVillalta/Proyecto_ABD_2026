/*
    Job de respaldo FULL diario a las 00:00 hora de El Salvador.
    En el servidor del proyecto, SQL Server usa hora UTC; por eso 00:00 SV
    corresponde a 06:00 UTC. Ajuste la hora si cambia la zona horaria.
    Ejecutar como sysadmin con SQL Server Agent iniciado.
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
    N''/var/opt/mssql/backup/full/Biblioteca_FULL_'' +
    CONVERT(CHAR(8), GETDATE(), 112) + N''_'' +
    REPLACE(CONVERT(CHAR(8), GETDATE(), 108), '':'', N'''') +
    N''.bak'';

BACKUP DATABASE [Biblioteca]
TO DISK = @Archivo
WITH COMPRESSION, CHECKSUM, STATS = 10;
';

IF DB_ID(N'Biblioteca') IS NULL
    THROW 51000, 'No existe la base de datos Biblioteca.', 1;

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'JOB_Biblioteca_FULL')
BEGIN
    EXEC msdb.dbo.sp_add_job
        @job_name = N'JOB_Biblioteca_FULL',
        @enabled = 1,
        @description = N'Respaldo FULL diario de Biblioteca.',
        @owner_login_name = N'sa',
        @job_id = @JobId OUTPUT;

    EXEC msdb.dbo.sp_add_jobstep
        @job_id = @JobId,
        @step_name = N'Respaldo FULL',
        @subsystem = N'TSQL',
        @database_name = N'master',
        @command = @Comando,
        @on_success_action = 1,
        @on_fail_action = 2;

    EXEC msdb.dbo.sp_add_jobserver
        @job_id = @JobId;
    PRINT N'Job JOB_Biblioteca_FULL creado.';
END
ELSE
BEGIN
    SELECT @JobId = job_id
    FROM msdb.dbo.sysjobs
    WHERE name = N'JOB_Biblioteca_FULL';
    PRINT N'El Job JOB_Biblioteca_FULL ya existe; no se duplico ni modifico.';
END;

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name = N'SCH_Biblioteca_FULL_0000_SV')
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name = N'SCH_Biblioteca_FULL_0000_SV',
        @enabled = 1,
        @freq_type = 4,
        @freq_interval = 1,
        @freq_subday_type = 1,
        @active_start_date = @Hoy,
        @active_start_time = 60000,
        @active_end_time = 235959,
        @schedule_id = @ScheduleId OUTPUT;
END
ELSE
BEGIN
    SELECT @ScheduleId = schedule_id
    FROM msdb.dbo.sysschedules
    WHERE name = N'SCH_Biblioteca_FULL_0000_SV';
END;

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobschedules js
    JOIN msdb.dbo.sysjobs j ON j.job_id = js.job_id
    WHERE j.name = N'JOB_Biblioteca_FULL'
      AND js.schedule_id = @ScheduleId
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule
        @job_name = N'JOB_Biblioteca_FULL',
        @schedule_id = @ScheduleId;
END;
GO
