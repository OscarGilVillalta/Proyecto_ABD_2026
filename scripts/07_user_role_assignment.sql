-- Asignación de roles para los usuarios
USE Biblioteca;
GO

-- Asignación a los usuarios del rol bibliotecario
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_bibliotecario')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Bibliotecario1'))
    ALTER ROLE rol_bibliotecario ADD MEMBER Bibliotecario1;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_bibliotecario')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Bibliotecario2'))
    ALTER ROLE rol_bibliotecario ADD MEMBER Bibliotecario2;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_bibliotecario')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Bibliotecario3'))
    ALTER ROLE rol_bibliotecario ADD MEMBER Bibliotecario3;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_bibliotecario')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Bibliotecario4'))
    ALTER ROLE rol_bibliotecario ADD MEMBER Bibliotecario4;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_bibliotecario')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Bibliotecario5'))
    ALTER ROLE rol_bibliotecario ADD MEMBER Bibliotecario5;


-- Asignación a los usuarios del rol analista
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_analista')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Analista1'))
    ALTER ROLE rol_analista ADD MEMBER Analista1;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_analista')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Analista2'))
    ALTER ROLE rol_analista ADD MEMBER Analista2;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_analista')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Analista3'))
    ALTER ROLE rol_analista ADD MEMBER Analista3;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_analista')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Analista4'))
    ALTER ROLE rol_analista ADD MEMBER Analista4;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_analista')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Analista5'))
    ALTER ROLE rol_analista ADD MEMBER Analista5;

-- Asignación a los usuarios del rol usuario_biblioteca
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_usuario_biblioteca')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Usuario1'))
    ALTER ROLE rol_usuario_biblioteca ADD MEMBER Usuario1;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_usuario_biblioteca')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Usuario2'))
    ALTER ROLE rol_usuario_biblioteca ADD MEMBER Usuario2;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_usuario_biblioteca')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Usuario3'))
    ALTER ROLE rol_usuario_biblioteca ADD MEMBER Usuario3;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_usuario_biblioteca')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Usuario4'))
    ALTER ROLE rol_usuario_biblioteca ADD MEMBER Usuario4;

IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_usuario_biblioteca')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Usuario5'))
    ALTER ROLE rol_usuario_biblioteca ADD MEMBER Usuario5;