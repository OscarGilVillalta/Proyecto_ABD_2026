/*
    Configura los 11 roles, sus permisos y las membresias.
    Requisito: ejecutar primero 05_server_logins.sql.
*/

USE Biblioteca;
GO
SET NOCOUNT ON;
GO

-- 1. Verificar que existan los seis usuarios.
IF DATABASE_PRINCIPAL_ID(N'oscar_villalta') IS NULL
    THROW 50001, 'Falta oscar_villalta. Ejecute primero 05_server_logins.sql.', 1;
IF DATABASE_PRINCIPAL_ID(N'fernando_rivera') IS NULL
    THROW 50002, 'Falta fernando_rivera. Ejecute primero 05_server_logins.sql.', 1;
IF DATABASE_PRINCIPAL_ID(N'jeremy_menjivar') IS NULL
    THROW 50003, 'Falta jeremy_menjivar. Ejecute primero 05_server_logins.sql.', 1;
IF DATABASE_PRINCIPAL_ID(N'diego_tolentino') IS NULL
    THROW 50004, 'Falta diego_tolentino. Ejecute primero 05_server_logins.sql.', 1;
IF DATABASE_PRINCIPAL_ID(N'eduardo_pacas') IS NULL
    THROW 50005, 'Falta eduardo_pacas. Ejecute primero 05_server_logins.sql.', 1;
IF DATABASE_PRINCIPAL_ID(N'profesor_biblioteca') IS NULL
    THROW 50006, 'Falta profesor_biblioteca. Ejecute primero 05_server_logins.sql.', 1;
GO

-- 2. Crear los roles si no existen.
IF DATABASE_PRINCIPAL_ID(N'rol_bibliotecario') IS NULL CREATE ROLE rol_bibliotecario;
GO
IF DATABASE_PRINCIPAL_ID(N'rol_usuario_biblioteca') IS NULL CREATE ROLE rol_usuario_biblioteca;
GO
IF DATABASE_PRINCIPAL_ID(N'rol_programador') IS NULL CREATE ROLE rol_programador;
GO
IF DATABASE_PRINCIPAL_ID(N'rol_seguridad') IS NULL CREATE ROLE rol_seguridad;
GO
IF DATABASE_PRINCIPAL_ID(N'rol_gestor_multas') IS NULL CREATE ROLE rol_gestor_multas;
GO
IF DATABASE_PRINCIPAL_ID(N'rol_gestor_prestamos') IS NULL CREATE ROLE rol_gestor_prestamos;
GO
IF DATABASE_PRINCIPAL_ID(N'rol_gestor_socios') IS NULL CREATE ROLE rol_gestor_socios;
GO
IF DATABASE_PRINCIPAL_ID(N'rol_gestor_rrhh') IS NULL CREATE ROLE rol_gestor_rrhh;
GO
IF DATABASE_PRINCIPAL_ID(N'rol_analista') IS NULL CREATE ROLE rol_analista;
GO
IF DATABASE_PRINCIPAL_ID(N'rol_profesor') IS NULL CREATE ROLE rol_profesor;
GO
IF DATABASE_PRINCIPAL_ID(N'rol_backup') IS NULL CREATE ROLE rol_backup;
GO

-- 3. Permisos de cada rol.
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::catalogo TO rol_bibliotecario;
GRANT SELECT ON SCHEMA::catalogo TO rol_usuario_biblioteca;

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::catalogo TO rol_programador;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::prestamos TO rol_programador;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::socios TO rol_programador;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::rrhh TO rol_programador;
GRANT EXECUTE ON SCHEMA::operaciones TO rol_programador;

GRANT ALTER ANY USER TO rol_seguridad;
GRANT ALTER ANY ROLE TO rol_seguridad;
GRANT VIEW DEFINITION TO rol_seguridad;

GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::socios.multa TO rol_gestor_multas;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::prestamos TO rol_gestor_prestamos;
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::socios.socio TO rol_gestor_socios;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::rrhh TO rol_gestor_rrhh;

GRANT SELECT ON SCHEMA::catalogo TO rol_analista;
GRANT SELECT ON SCHEMA::prestamos TO rol_analista;
GRANT SELECT ON SCHEMA::socios TO rol_analista;

GRANT SELECT ON SCHEMA::catalogo TO rol_profesor;
GRANT SELECT ON SCHEMA::prestamos TO rol_profesor;
GRANT SELECT ON SCHEMA::socios TO rol_profesor;
GO

-- rol_backup pertenece al rol integrado db_backupoperator.
IF NOT EXISTS (
    SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'db_backupoperator')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'rol_backup')
)
    ALTER ROLE db_backupoperator ADD MEMBER rol_backup;
GO

-- 4. Asignación a los usuarios el rol_programador.
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_programador')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'oscar_villalta'))
    ALTER ROLE rol_programador ADD MEMBER oscar_villalta;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_programador')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'fernando_rivera'))
    ALTER ROLE rol_programador ADD MEMBER fernando_rivera;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_programador')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'jeremy_menjivar'))
    ALTER ROLE rol_programador ADD MEMBER jeremy_menjivar;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_programador')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'diego_tolentino'))
    ALTER ROLE rol_programador ADD MEMBER diego_tolentino;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_programador')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'eduardo_pacas'))
    ALTER ROLE rol_programador ADD MEMBER eduardo_pacas;

-- El profesor pertenece a rol_profesor.
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_profesor')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'profesor_biblioteca'))
    ALTER ROLE rol_profesor ADD MEMBER profesor_biblioteca;
GO

-- 5. Consultas de verificacion.
SELECT name AS rol
FROM sys.database_principals
WHERE type = 'R' AND name LIKE 'rol_%'
ORDER BY name;

SELECT r.name AS rol, u.name AS usuario
FROM sys.database_role_members AS rm
JOIN sys.database_principals AS r ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals AS u ON rm.member_principal_id = u.principal_id
WHERE r.name LIKE 'rol_%'
ORDER BY r.name, u.name;

SELECT p.name AS rol, dp.permission_name, dp.state_desc, dp.class_desc
FROM sys.database_permissions AS dp
JOIN sys.database_principals AS p ON dp.grantee_principal_id = p.principal_id
WHERE p.name LIKE 'rol_%'
ORDER BY p.name, dp.permission_name;

PRINT 'Configuracion de roles, permisos y membresias verificada.';
GO
