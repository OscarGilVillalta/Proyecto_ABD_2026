CREATE DATABASE Biblioteca;
GO

USE Biblioteca;
GO

CREATE SCHEMA rrhh AUTHORIZATION dbo;
GO

CREATE SCHEMA socios AUTHORIZATION dbo;
GO

CREATE SCHEMA catalogo AUTHORIZATION dbo;
GO

CREATE SCHEMA prestamos AUTHORIZATION dbo;
GO

CREATE SCHEMA operaciones AUTHORIZATION dbo;
GO

-- ==========================================================
-- PARTE ADMINISTRATIVA DE LA BIBLIOTECA
-- ==========================================================

--! Tabla Empleado
CREATE TABLE rrhh.empleado
(
    id_empleado INT IDENTITY(1,1),
    dui VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,

    CONSTRAINT pk_empleado PRIMARY KEY (id_empleado),
    CONSTRAINT uq_dui_empleado UNIQUE (dui),
    CONSTRAINT ck_sexo_empleado CHECK (sexo IN ('M', 'F'))
);
GO

--! Tabla Socio
CREATE TABLE socios.socio
(
    id_socio INT IDENTITY(1,1),
    dui VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,

    CONSTRAINT pk_socio PRIMARY KEY (id_socio),
    CONSTRAINT uq_dui_socio UNIQUE (dui),
    CONSTRAINT ck_sexo_socio CHECK (sexo IN ('M', 'F'))
);
GO

--! Tabla Libro
CREATE TABLE catalogo.libro
(
    id_libro INT IDENTITY(1,1), 
    nombre VARCHAR(150) NOT NULL,
    fecha_publicacion DATE NOT NULL,

    CONSTRAINT pk_libro PRIMARY KEY (id_libro)
);
GO

--! Tabla Prestamo
CREATE TABLE prestamos.prestamo
(
    id_prestamo INT IDENTITY(1,1),
    fecha_prestamo DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    fecha_limite DATE NOT NULL,
    fecha_devolucion DATETIME2,
    estado VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    id_empleado INT NOT NULL,
    id_socio INT NOT NULL,

    CONSTRAINT pk_prestamo PRIMARY KEY (id_prestamo),

    CONSTRAINT ck_estado_prestamo
        CHECK (estado IN ('ACTIVO', 'DEVUELTO', 'ATRASADO')),

    CONSTRAINT fk_id_empleado_prestamo
        FOREIGN KEY (id_empleado)
        REFERENCES rrhh.empleado(id_empleado)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT fk_id_socio_prestamo
        FOREIGN KEY (id_socio)
        REFERENCES socios.socio(id_socio)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO

--! Tabla Multa
CREATE TABLE socios.multa
(
    id_multa INT IDENTITY(1,1),
    fecha_multa DATE NOT NULL,
    estado VARCHAR(15) NOT NULL DEFAULT 'PENDIENTE',
    monto DECIMAL(10,2) NOT NULL,
    id_prestamo INT NOT NULL,

    CONSTRAINT pk_multa PRIMARY KEY (id_multa),

    CONSTRAINT ck_estado_multa
        CHECK (estado IN ('PENDIENTE', 'PAGADO', 'CANCELADO')),

    CONSTRAINT ck_monto_multa
        CHECK (monto > 0),

    CONSTRAINT fk_id_prestamo_multa
        FOREIGN KEY (id_prestamo)
        REFERENCES prestamos.prestamo(id_prestamo)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO

--! Tabla Ejemplar
CREATE TABLE catalogo.ejemplar
(
    id_ejemplar INT IDENTITY(1,1),
    estado VARCHAR(20) NOT NULL DEFAULT 'LIBRE',
    id_libro INT NOT NULL,

    CONSTRAINT pk_ejemplar PRIMARY KEY (id_ejemplar),

    CONSTRAINT ck_estado_ejemplar
        CHECK (estado IN ('LIBRE', 'PRESTADO', 'RESERVADO', 'FUERA_SERVICIO')),

    CONSTRAINT fk_id_libro_ejemplar
        FOREIGN KEY (id_libro)
        REFERENCES catalogo.libro(id_libro)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO

--! Tabla Prestamo Ejemplar
CREATE TABLE prestamos.prestamo_ejemplar
(
    id_prestamo INT NOT NULL,
    id_ejemplar INT NOT NULL,

    CONSTRAINT pk_prestamo_ejemplar
        PRIMARY KEY (id_prestamo, id_ejemplar),

    CONSTRAINT fk_id_prestamo_prestamo_ejemplar
        FOREIGN KEY (id_prestamo)
        REFERENCES prestamos.prestamo(id_prestamo)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT fk_id_ejemplar_prestamo_ejemplar
        FOREIGN KEY (id_ejemplar)
        REFERENCES catalogo.ejemplar(id_ejemplar)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO

-- ==========================================================
-- PARTE DE LIBROS DE LA BIBLIOTECA
-- ==========================================================

--! Tabla Editorial
CREATE TABLE catalogo.editorial
(
    id_editorial INT IDENTITY(1,1),
    nombre VARCHAR(150) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(250) NOT NULL,

    CONSTRAINT pk_editorial PRIMARY KEY (id_editorial),

    CONSTRAINT uq_nombre_editorial UNIQUE (nombre),
    CONSTRAINT uq_correo_editorial UNIQUE (correo),

    CONSTRAINT ck_correo_editorial
        CHECK (correo LIKE '%@%'),

    CONSTRAINT ck_telefono_editorial
        CHECK (telefono NOT LIKE '%[^0-9+ -]%')
);
GO

--! Tabla Libro Editorial
CREATE TABLE catalogo.libro_editorial
(
    id_libro INT NOT NULL,
    id_editorial INT NOT NULL,

    CONSTRAINT pk_libro_editorial
        PRIMARY KEY (id_libro, id_editorial),

    CONSTRAINT fk_id_libro_libro_editorial
        FOREIGN KEY (id_libro)
        REFERENCES catalogo.libro(id_libro)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT fk_id_editorial_libro_editorial
        FOREIGN KEY (id_editorial)
        REFERENCES catalogo.editorial(id_editorial)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO

--! Tabla Autor
CREATE TABLE catalogo.autor
(
    id_autor INT IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,

    CONSTRAINT pk_autor PRIMARY KEY (id_autor),

    CONSTRAINT ck_sexo_autor
        CHECK (sexo IN ('M', 'F'))
);
GO

--! Tabla Genero
CREATE TABLE catalogo.genero
(
    id_genero INT IDENTITY(1,1),
    nombre VARCHAR(150) NOT NULL,

    CONSTRAINT pk_genero PRIMARY KEY (id_genero),

    CONSTRAINT uq_nombre_genero UNIQUE (nombre)
);
GO

--! Tabla Libro Genero
CREATE TABLE catalogo.libro_genero
(
    id_genero INT NOT NULL,
    id_libro INT NOT NULL,

    CONSTRAINT pk_libro_genero
        PRIMARY KEY (id_genero, id_libro),

    CONSTRAINT fk_id_genero_libro_genero
        FOREIGN KEY (id_genero)
        REFERENCES catalogo.genero(id_genero)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT fk_id_libro_libro_genero
        FOREIGN KEY (id_libro)
        REFERENCES catalogo.libro(id_libro)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO

--! Tabla Libro Autor
CREATE TABLE catalogo.libro_autor
(
    id_libro INT NOT NULL,
    id_autor INT NOT NULL,

    CONSTRAINT pk_libro_autor
        PRIMARY KEY (id_libro, id_autor),

    CONSTRAINT fk_id_libro_libro_autor
        FOREIGN KEY (id_libro)
        REFERENCES catalogo.libro(id_libro)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT fk_id_autor_libro_autor
        FOREIGN KEY (id_autor)
        REFERENCES catalogo.autor(id_autor)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
GO