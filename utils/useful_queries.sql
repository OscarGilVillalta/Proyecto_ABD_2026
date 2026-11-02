-- Ver esquemas creados
SELECT
    name AS schema_name,
    schema_id,
    USER_NAME(principal_id) AS owner
FROM sys.schemas
ORDER BY name;

-- Verificar auditoria de la base de datos si esta activa o inactiva
SELECT
    name,
    is_state_enabled
FROM sys.database_audit_specifications;
GO

-- Ver el estado de la auditoria del servidot
SELECT
    name,
    status_desc,
    audit_file_path
FROM sys.dm_server_audit_status;
GO