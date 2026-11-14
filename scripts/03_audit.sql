USE Biblioteca;
GO

-- ==========================================================
-- AUDITORIA 1: OPERACIONES PRINCIPALES DE LA BIBLIOTECA
-- ==========================================================

USE master;
GO

-- Creamos la configuracion de la auditoria
CREATE SERVER AUDIT Audit_Biblioteca
TO FILE
(
   FILEPATH = '/audit/',
   MAXSIZE = 100 MB,
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
-- Especificacion de auditoria de biblioteca
-- ==========================================================

USE Biblioteca;
GO

-- Creamos la especificacion de auditoria
CREATE DATABASE AUDIT SPECIFICATION AuditSpec_Biblioteca
FOR SERVER AUDIT Audit_Biblioteca

-- Definimos las acciones que seran registradas por la auditoria
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

-- Activamos la especificacion de auditoria
ALTER DATABASE AUDIT SPECIFICATION AuditSpec_Biblioteca
WITH (STATE = ON);
GO


-- ==========================================================
-- AUDITORIA 2: CATALOGO DE LA BIBLIOTECA
-- ==========================================================

USE master;
GO

-- Creamos la configuracion de la auditoria
CREATE SERVER AUDIT Audit_Catalogo
TO FILE
(
   FILEPATH = '/audit/',
   MAXSIZE = 100 MB,
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
ALTER SERVER AUDIT Audit_Catalogo
WITH (STATE = ON);
GO

-- ==========================================================
-- Especificacion de auditoria de catalogo
-- ==========================================================

USE Biblioteca;
GO

-- Creamos la especificacion de auditoria
CREATE DATABASE AUDIT SPECIFICATION AuditSpec_Catalogo
FOR SERVER AUDIT Audit_Catalogo

-- Definimos las acciones que seran registradas por la auditoria
ADD (INSERT ON OBJECT::catalogo.libro BY PUBLIC),
ADD (UPDATE ON OBJECT::catalogo.libro BY PUBLIC),
ADD (DELETE ON OBJECT::catalogo.libro BY PUBLIC),

ADD (INSERT ON OBJECT::catalogo.autor BY PUBLIC),
ADD (UPDATE ON OBJECT::catalogo.autor BY PUBLIC),
ADD (DELETE ON OBJECT::catalogo.autor BY PUBLIC),

ADD (INSERT ON OBJECT::catalogo.editorial BY PUBLIC),
ADD (UPDATE ON OBJECT::catalogo.editorial BY PUBLIC),
ADD (DELETE ON OBJECT::catalogo.editorial BY PUBLIC),

ADD (INSERT ON OBJECT::catalogo.genero BY PUBLIC),
ADD (UPDATE ON OBJECT::catalogo.genero BY PUBLIC),
ADD (DELETE ON OBJECT::catalogo.genero BY PUBLIC),

ADD (INSERT ON OBJECT::catalogo.ejemplar BY PUBLIC),
ADD (UPDATE ON OBJECT::catalogo.ejemplar BY PUBLIC),
ADD (DELETE ON OBJECT::catalogo.ejemplar BY PUBLIC);
GO

-- Activamos la especificacion de auditoria
ALTER DATABASE AUDIT SPECIFICATION AuditSpec_Catalogo
WITH (STATE = ON);
GO


-- ==========================================================
-- AUDITORIA 3: RECURSOS HUMANOS
-- ==========================================================

USE master;
GO

-- Creamos la configuracion de la auditoria
CREATE SERVER AUDIT Audit_RRHH
TO FILE
(
   FILEPATH = '/audit/',
   MAXSIZE = 100 MB,
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
ALTER SERVER AUDIT Audit_RRHH
WITH (STATE = ON);
GO

-- ==========================================================
-- Especificacion de auditoria de recursos humanos
-- ==========================================================

USE Biblioteca;
GO

-- Creamos la especificacion de auditoria
CREATE DATABASE AUDIT SPECIFICATION AuditSpec_RRHH
FOR SERVER AUDIT Audit_RRHH

-- Definimos las acciones que seran registradas por la auditoria
ADD (INSERT ON OBJECT::rrhh.empleado BY PUBLIC),
ADD (UPDATE ON OBJECT::rrhh.empleado BY PUBLIC),
ADD (DELETE ON OBJECT::rrhh.empleado BY PUBLIC);
GO

-- Activamos la especificacion de auditoria
ALTER DATABASE AUDIT SPECIFICATION AuditSpec_RRHH
WITH (STATE = ON);
GO


-- ==========================================================
-- VERIFICACION DE SERVER AUDITS
-- ==========================================================

USE master;
GO

SELECT
    name,
    status_desc,
    audit_file_path
FROM sys.dm_server_audit_status;
GO


-- ==========================================================
-- VERIFICACION DE DATABASE AUDIT SPECIFICATIONS
-- ==========================================================

USE Biblioteca;
GO

SELECT
    name,
    is_state_enabled
FROM sys.database_audit_specifications;
GO