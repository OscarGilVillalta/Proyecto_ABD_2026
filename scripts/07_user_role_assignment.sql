-- Asignación de roles para los usuarios en la base de datos
USE Biblioteca;
GO

-- 1. Asignación a los usuarios del rol bibliotecario
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_bibliotecario')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Bibliotecario'))
    ALTER ROLE rol_bibliotecario ADD MEMBER Bibliotecario;

-- 2. Asignación a los usuarios del rol analista
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_analista')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Analista'))
    ALTER ROLE rol_analista ADD MEMBER Analista;

-- 3. Asignación a los usuarios del rol usuario_biblioteca
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_usuario_biblioteca')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Usuario'))
    ALTER ROLE rol_usuario_biblioteca ADD MEMBER Usuario;

-- 4. Asignación a los usuarios del rol gestor_multas
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_gestor_multas')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Gestor_multas'))
    ALTER ROLE rol_gestor_multas ADD MEMBER Gestor_multas;

-- 5. Asignación a los usuarios del rol gestor_rrhh
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_gestor_rrhh')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Gestor_rrhh'))
    ALTER ROLE rol_gestor_rrhh ADD MEMBER Gestor_rrhh;

-- 6. Asignación a los usuarios del rol gestor_socios
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_gestor_socios')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Gestor_socios'))
    ALTER ROLE rol_gestor_socios ADD MEMBER Gestor_socios;

-- 7. Asignación a los usuarios del rol gestor_prestamos
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_gestor_prestamos')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Gestor_prestamos'))
    ALTER ROLE rol_gestor_prestamos ADD MEMBER Gestor_prestamos;

-- 8. Asignación a los usuarios del rol backup
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_backup')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Operador_backup'))
    ALTER ROLE rol_backup ADD MEMBER Operador_backup;

-- 9. Asignación a los usuarios del rol seguridad
IF NOT EXISTS (SELECT 1 FROM sys.database_role_members
    WHERE role_principal_id = DATABASE_PRINCIPAL_ID(N'rol_seguridad')
      AND member_principal_id = DATABASE_PRINCIPAL_ID(N'Seguridad'))
    ALTER ROLE rol_seguridad ADD MEMBER Seguridad;