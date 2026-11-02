USE Biblioteca;
GO

-- ==========================================================
-- AUDITORIA DE BASE DE DATOS
-- ==========================================================

USE master;
GO

-- Creamos la configuracion de la auditoria
CREATE SERVER AUDIT Audit_Biblioteca
TO FILE
(
   FILEPATH = '/audit/',
   MAXSIZE= 100 MB,
   MAX_ROLLOVER_FILES = 10,
   RESERVE_DISK_SPACE = OFF
)
WITH 
(
  QUEUE_DELAY = 1000,
  ON_FAILURE = CONTINUE
);
GO

-- Encendemos la auditoria
ALTER SERVER AUDIT Audit_Biblioteca
WITH (STATE = ON);
GO

-- ==========================================================
-- Especificacion de auditoria de base de datos
-- ==========================================================

USE Biblioteca;
GO

-- Creamos la auditoria que estaria en la base de datos.
CREATE DATABASE AUDIT SPECIFICATION AuditSpec_Biblioteca
FOR SERVER AUDIT Audit_Biblioteca

-- Damos los permisos a la auditoria para que pueda registrar
ADD (INSERT ON OBJECT::prestamos.prestamo BY PUBLIC),
ADD (UPDATE ON OBJECT::prestamos.prestamo BY PUBLIC),
ADD (DELETE ON OBJECT::prestamos.prestamo BY PUBLIC),

ADD (INSERT ON OBJECT::socios.multa BY PUBLIC),
ADD (UPDATE ON OBJECT::socios.multa BY PUBLIC),
ADD (DELETE ON OBJECT::socios.multa BY PUBLIC),

ADD (INSERT ON OBJECT::socios.socio BY PUBLIC),
ADD (UPDATE ON OBJECT::socios.socio BY PUBLIC),
ADD (DELETE ON OBJECT::socios.socio BY PUBLIC),

ADD (EXECUTE ON OBJECT::operaciones.sp_procesar_prestamo BY PUBLIC);
GO

-- Activamos la auditoria 
ALTER DATABASE AUDIT SPECIFICATION AuditSpec_Biblioteca
WITH (STATE = ON);
GO

