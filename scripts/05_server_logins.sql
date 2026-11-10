/*
    Proyecto: Biblioteca
    Archivo: 05_server_logins.sql

    Crea los logins del servidor y los vincula con los usuarios
    de la base Biblioteca restaurada.

    Antes de ejecutar:
    - Reemplazar las seis contraseñas provisionales por contraseñas
      seguras y distintas.
    - Restaurar primero la base de datos Biblioteca.
*/

USE master;
GO

-- 1. Crear logins si no existen.
-- Si ya existen, este script no cambia sus contraseñas.

IF SUSER_ID(N'oscar_villalta') IS NULL
    CREATE LOGIN [oscar_villalta] WITH PASSWORD = 'Oscar_Biblioteca2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'fernando_rivera') IS NULL
    CREATE LOGIN [fernando_rivera] WITH PASSWORD = 'Fernando_Biblioteca2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'jeremy_menjivar') IS NULL
    CREATE LOGIN [jeremy_menjivar] WITH PASSWORD = 'Jeremy_Biblioteca2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'diego_tolentino') IS NULL
    CREATE LOGIN [diego_tolentino] WITH PASSWORD = 'Diego_Biblioteca2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'eduardo_pacas') IS NULL
    CREATE LOGIN [eduardo_pacas] WITH PASSWORD = 'Eduardo_Biblioteca2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO
IF SUSER_ID(N'profesor_biblioteca') IS NULL
    CREATE LOGIN [profesor_biblioteca] WITH PASSWORD = 'Docente_Acceso2026!', CHECK_POLICY = ON, CHECK_EXPIRATION = OFF;
GO

-- 2. Vincular los logins con los usuarios que vienen en el respaldo.
-- Si el usuario no existe, crearlo asociado al login.

USE Biblioteca;
GO

IF DATABASE_PRINCIPAL_ID(N'oscar_villalta') IS NULL
    CREATE USER [oscar_villalta] FOR LOGIN [oscar_villalta];
ELSE
    ALTER USER [oscar_villalta] WITH LOGIN = [oscar_villalta];
GO

IF DATABASE_PRINCIPAL_ID(N'fernando_rivera') IS NULL
    CREATE USER [fernando_rivera] FOR LOGIN [fernando_rivera];
ELSE
    ALTER USER [fernando_rivera] WITH LOGIN = [fernando_rivera];
GO

IF DATABASE_PRINCIPAL_ID(N'jeremy_menjivar') IS NULL
    CREATE USER [jeremy_menjivar] FOR LOGIN [jeremy_menjivar];
ELSE
    ALTER USER [jeremy_menjivar] WITH LOGIN = [jeremy_menjivar];
GO

IF DATABASE_PRINCIPAL_ID(N'diego_tolentino') IS NULL
    CREATE USER [diego_tolentino] FOR LOGIN [diego_tolentino];
ELSE
    ALTER USER [diego_tolentino] WITH LOGIN = [diego_tolentino];
GO

IF DATABASE_PRINCIPAL_ID(N'eduardo_pacas') IS NULL
    CREATE USER [eduardo_pacas] FOR LOGIN [eduardo_pacas];
ELSE
    ALTER USER [eduardo_pacas] WITH LOGIN = [eduardo_pacas];
GO

IF DATABASE_PRINCIPAL_ID(N'profesor_biblioteca') IS NULL
    CREATE USER [profesor_biblioteca] FOR LOGIN [profesor_biblioteca];
ELSE
    ALTER USER [profesor_biblioteca] WITH LOGIN = [profesor_biblioteca];
GO

-- 3. Verificar la vinculacion entre usuarios y logins.
SELECT
    dp.name AS usuario_base_datos,
    sp.name AS login_servidor,
    CASE WHEN sp.sid = dp.sid THEN 'Vinculado' ELSE 'Revisar' END AS estado
FROM sys.database_principals AS dp
LEFT JOIN sys.server_principals AS sp ON dp.sid = sp.sid
WHERE dp.name IN (
    N'oscar_villalta', N'fernando_rivera', N'jeremy_menjivar',
    N'diego_tolentino', N'eduardo_pacas', N'profesor_biblioteca'
)
ORDER BY dp.name;
GO
