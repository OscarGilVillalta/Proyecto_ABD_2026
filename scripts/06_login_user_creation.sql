-- Creacion de demas logins y usuarios para los roles
USE master;
GO

-- (cambiar todas las contraseñas al momento de ejecutar)

-- 1. Login para el rol bibliotecario
IF SUSER_ID(N'Bibliotecario') IS NULL
    CREATE LOGIN [Bibliotecario] WITH PASSWORD = 'Bibliotecario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- 2. Login para el rol analista
IF SUSER_ID(N'Analista') IS NULL
    CREATE LOGIN [Analista] WITH PASSWORD = 'Analista2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- 3. Login para rol usuario_biblioteca
IF SUSER_ID(N'Usuario') IS NULL
    CREATE LOGIN [Usuario] WITH PASSWORD = 'Usuario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- 4. Login para rol gestor_multas
IF SUSER_ID(N'Gestor_multas') IS NULL
    CREATE LOGIN [Gestor_multas] WITH PASSWORD = 'Gestor_m2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- 5. Login para rol gestor_rrhh
IF SUSER_ID(N'Gestor_rrhh') IS NULL
    CREATE LOGIN [Gestor_rrhh] WITH PASSWORD = 'Gestor_r2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- 6. Login para rol gestor_socios
IF SUSER_ID(N'Gestor_socios') IS NULL
    CREATE LOGIN [Gestor_socios] WITH PASSWORD = 'Gestor_s2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- 7. Login para rol gestor_prestamos
IF SUSER_ID(N'Gestor_prestamos') IS NULL
    CREATE LOGIN [Gestor_prestamos] WITH PASSWORD = 'Gestor_p2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- 8. Login para rol backup
IF SUSER_ID(N'Operador_backup') IS NULL
    CREATE LOGIN [Operador_backup] WITH PASSWORD = 'Backup2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- 9. Login para rol seguridad
IF SUSER_ID(N'Seguridad') IS NULL
    CREATE LOGIN [Seguridad] WITH PASSWORD = 'Seguridad2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- Creacion de usuarios para la base de datos
USE Biblioteca;
GO

-- 1. Usuario para el rol bilbiotecario
IF DATABASE_PRINCIPAL_ID(N'Bibliotecario') IS NULL
    CREATE USER [Bibliotecario] FOR LOGIN [Bibliotecario];
ELSE
    ALTER USER [Bibliotecario] WITH LOGIN = [Bibliotecario];
GO

-- 2. Usuario para el rol analista
IF DATABASE_PRINCIPAL_ID(N'Analista') IS NULL
    CREATE USER [Analista] FOR LOGIN [Analista];
ELSE
    ALTER USER [Analista] WITH LOGIN = [Analista];
GO

-- 3. Usuario para el rol usuario_biblioteca
IF DATABASE_PRINCIPAL_ID(N'Usuario') IS NULL
    CREATE USER [Usuario] FOR LOGIN [Usuario];
ELSE
    ALTER USER [Usuario] WITH LOGIN = [Usuario];
GO

-- 4. Usuario para el rol gestor_multas
IF DATABASE_PRINCIPAL_ID(N'Gestor_multas') IS NULL
    CREATE USER [Gestor_multas] FOR LOGIN [Gestor_multas];
ELSE
    ALTER USER [Gestor_multas] WITH LOGIN = [Gestor_multas];
GO

-- 5. Usuario para el rol gestor_rrhh
IF DATABASE_PRINCIPAL_ID(N'Gestor_multas') IS NULL
    CREATE USER [Gestor_rrhh] FOR LOGIN [Gestor_rrhh];
ELSE
    ALTER USER [Gestor_rrhh] WITH LOGIN = [Gestor_rrhh];
GO

-- 6. Usuario para el rol gestor_socios
IF DATABASE_PRINCIPAL_ID(N'Gestor_socios') IS NULL
    CREATE USER [Gestor_socios] FOR LOGIN [Gestor_socios];
ELSE
    ALTER USER [Gestor_socios] WITH LOGIN = [Gestor_socios];
GO

-- 7. Usuario para el gestor_prestamos
IF DATABASE_PRINCIPAL_ID(N'Gestor_prestamos') IS NULL
    CREATE USER [Gestor_prestamos] FOR LOGIN [Gestor_prestamos];
ELSE
    ALTER USER [Gestor_prestamos] WITH LOGIN = [Gestor_prestamos];
GO

-- 8. Usuario para el rol backup
IF DATABASE_PRINCIPAL_ID(N'Operador_backup') IS NULL
    CREATE USER [Operador_backup] FOR LOGIN [Operador_backup];
ELSE
    ALTER USER [Operador_backup] WITH LOGIN = [Operador_backup];
GO

-- 9. Usuario para el rol seguridad
IF DATABASE_PRINCIPAL_ID(N'Seguridad') IS NULL
    CREATE USER [Seguridad] FOR LOGIN [Seguridad];
ELSE
    ALTER USER [Seguridad] WITH LOGIN = [Seguridad];
GO