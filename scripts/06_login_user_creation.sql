-- Creacion de demas logins y usuarios para los roles
USE master;
GO

-- (cambiar las contraseñas al momento de ejecutar)

-- Logins para el rol bibliotecario
IF SUSER_ID(N'Bibliotecario1') IS NULL
    CREATE LOGIN [Bibliotecario1] WITH PASSWORD = 'Bibliotecario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Bibliotecario2') IS NULL
    CREATE LOGIN [Bibliotecario2] WITH PASSWORD = 'Bibliotecario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Bibliotecario3') IS NULL
    CREATE LOGIN [Bibliotecario3] WITH PASSWORD = 'Bibliotecario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Bibliotecario4') IS NULL
    CREATE LOGIN [Bibliotecario4] WITH PASSWORD = 'Bibliotecario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Bibliotecario5') IS NULL
    CREATE LOGIN [Bibliotecario5] WITH PASSWORD = 'Bibliotecario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- Logins para el rol analista
IF SUSER_ID(N'Analista1') IS NULL
    CREATE LOGIN [Analista1] WITH PASSWORD = 'Analista2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Analista2') IS NULL
    CREATE LOGIN [Analista2] WITH PASSWORD = 'Analista2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Analista3') IS NULL
    CREATE LOGIN [Analista3] WITH PASSWORD = 'Analista2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Analista4') IS NULL
    CREATE LOGIN [Analista4] WITH PASSWORD = 'Analista2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Analista5') IS NULL
    CREATE LOGIN [Analista5] WITH PASSWORD = 'Analista2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- Logins para rol usuario_biblioteca
IF SUSER_ID(N'Usuario1') IS NULL
    CREATE LOGIN [Usuario1] WITH PASSWORD = 'Usuario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Usuario2') IS NULL
    CREATE LOGIN [Usuario2] WITH PASSWORD = 'Usuario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Usuario3') IS NULL
    CREATE LOGIN [Usuario3] WITH PASSWORD = 'Usuario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Usuario4') IS NULL
    CREATE LOGIN [Usuario4] WITH PASSWORD = 'Usuario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'Usuario5') IS NULL
    CREATE LOGIN [Usuario5] WITH PASSWORD = 'Usuario2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- Creacion de usuarios para la base de datos
USE Biblioteca;
GO

-- Usuarios para el rol bilbiotecario
IF DATABASE_PRINCIPAL_ID(N'Bibliotecario1') IS NULL
    CREATE USER [Bibliotecario1] FOR LOGIN [Bibliotecario1];
ELSE
    ALTER USER [Bibliotecario1] WITH LOGIN = [Bibliotecario1];
GO

IF DATABASE_PRINCIPAL_ID(N'Bibliotecario2') IS NULL
    CREATE USER [Bibliotecario2] FOR LOGIN [Bibliotecario2];
ELSE
    ALTER USER [Bibliotecario2] WITH LOGIN = [Bibliotecario2];
GO

IF DATABASE_PRINCIPAL_ID(N'Bibliotecario3') IS NULL
    CREATE USER [Bibliotecario3] FOR LOGIN [Bibliotecario3];
ELSE
    ALTER USER [Bibliotecario3] WITH LOGIN = [Bibliotecario3];
GO

IF DATABASE_PRINCIPAL_ID(N'Bibliotecario4') IS NULL
    CREATE USER [Bibliotecario4] FOR LOGIN [Bibliotecario4];
ELSE
    ALTER USER [Bibliotecario4] WITH LOGIN = [Bibliotecario4];
GO

IF DATABASE_PRINCIPAL_ID(N'Bibliotecario5') IS NULL
    CREATE USER [Bibliotecario5] FOR LOGIN [Bibliotecario5];
ELSE
    ALTER USER [Bibliotecario5] WITH LOGIN = [Bibliotecario5];
GO

-- Usuarios para el rol analista
IF DATABASE_PRINCIPAL_ID(N'Analista1') IS NULL
    CREATE USER [Analista1] FOR LOGIN [Analista1];
ELSE
    ALTER USER [Analista1] WITH LOGIN = [Analista1];
GO

IF DATABASE_PRINCIPAL_ID(N'Analista2') IS NULL
    CREATE USER [Analista2] FOR LOGIN [Analista2];
ELSE
    ALTER USER [Analista2] WITH LOGIN = [Analista2];
GO

IF DATABASE_PRINCIPAL_ID(N'Analista3') IS NULL
    CREATE USER [Analista3] FOR LOGIN [Analista3];
ELSE
    ALTER USER [Analista3] WITH LOGIN = [Analista3];
GO

IF DATABASE_PRINCIPAL_ID(N'Analista4') IS NULL
    CREATE USER [Analista4] FOR LOGIN [Analista4];
ELSE
    ALTER USER [Analista4] WITH LOGIN = [Analista4];
GO

IF DATABASE_PRINCIPAL_ID(N'Analista5') IS NULL
    CREATE USER [Analista5] FOR LOGIN [Analista5];
ELSE
    ALTER USER [Analista5] WITH LOGIN = [Analista5];
GO

-- Usuarios para el rol usuario_biblioteca
IF DATABASE_PRINCIPAL_ID(N'Usuario1') IS NULL
    CREATE USER [Usuario1] FOR LOGIN [Usuario1];
ELSE
    ALTER USER [Usuario1] WITH LOGIN = [Usuario1];
GO

IF DATABASE_PRINCIPAL_ID(N'Usuario2') IS NULL
    CREATE USER [Usuario2] FOR LOGIN [Usuario2];
ELSE
    ALTER USER [Usuario2] WITH LOGIN = [Usuario2];
GO

IF DATABASE_PRINCIPAL_ID(N'Usuario3') IS NULL
    CREATE USER [Usuario3] FOR LOGIN [Usuario3];
ELSE
    ALTER USER [Usuario3] WITH LOGIN = [Usuario3];
GO

IF DATABASE_PRINCIPAL_ID(N'Usuario4') IS NULL
    CREATE USER [Usuario4] FOR LOGIN [Usuario4];
ELSE
    ALTER USER [Usuario4] WITH LOGIN = [Usuario4];
GO

IF DATABASE_PRINCIPAL_ID(N'Usuario5') IS NULL
    CREATE USER [Usuario5] FOR LOGIN [Usuario5];
ELSE
    ALTER USER [Usuario5] WITH LOGIN = [Usuario5];
GO