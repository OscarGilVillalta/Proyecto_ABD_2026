# Proyecto ABD 2026 - Sistema de Biblioteca

Base de datos relacional para la administración de una biblioteca, implementada en **SQL Server**. Incluye el esquema de tablas, triggers de validación, procedimientos almacenados y la carga masiva de datos de prueba desde archivos CSV.

## Estructura del repositorio

| Archivo | Descripción |
| --- | --- |
| `Base_Datos.sql` | Crea la base de datos `Proyecto` y todas las tablas con sus llaves y restricciones. |
| `Triggers_ProcesosAlmacenados.sql` | Crea los triggers y procedimientos almacenados del negocio. |
| `utils/upload_data.sql` | Carga masiva de los CSV (`BULK INSERT`) y resumen de filas por tabla. |
| `data/*.csv` | Datos de prueba de cada tabla. |
| `db_diagrama/Diagrama_Relacional.png` | Diagrama relacional de la base de datos. |

## Orden de ejecución

1. `Base_Datos.sql` — crea la base y el esquema.
2. `Triggers_ProcesosAlmacenados.sql` — crea triggers y procedimientos.
3. Copiar la carpeta `data` al contenedor de SQL Server y ejecutar `utils/upload_data.sql`.

> La carga usa rutas del contenedor (`/data/data/<tabla>.csv`). Ver las instrucciones comentadas al inicio de `utils/upload_data.sql`.

## Tablas

### Empleado

Personal que atiende los préstamos.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_empleado` | INT IDENTITY | PK |
| `dui` | VARCHAR(10) | NOT NULL, UNIQUE |
| `nombre` | VARCHAR(100) | NOT NULL |
| `apellido` | VARCHAR(100) | NOT NULL |
| `fecha_nacimiento` | DATE | NOT NULL |
| `sexo` | CHAR(1) | NOT NULL, CHECK `M`/`F` |

### Socio

Usuarios que solicitan préstamos.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_socio` | INT IDENTITY | PK |
| `dui` | VARCHAR(10) | NOT NULL, UNIQUE |
| `nombre` | VARCHAR(100) | NOT NULL |
| `apellido` | VARCHAR(100) | NOT NULL |
| `fecha_nacimiento` | DATE | NOT NULL |
| `sexo` | CHAR(1) | NOT NULL, CHECK `M`/`F` |

### Libro

Obras disponibles en la biblioteca.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_libro` | INT IDENTITY | PK |
| `nombre` | VARCHAR(150) | NOT NULL |
| `fecha_publicacion` | DATE | NOT NULL |

### Prestamo

Registro de préstamos realizados.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_prestamo` | INT IDENTITY | PK |
| `fecha_prestamo` | DATETIME2 | NOT NULL, DEFAULT `SYSDATETIME()` |
| `fecha_limite` | DATE | NOT NULL |
| `fecha_devolucion` | DATETIME2 | NULL |
| `estado` | VARCHAR(15) | NOT NULL, DEFAULT `ACTIVO`, CHECK `ACTIVO`/`DEVUELTO`/`ATRASADO` |
| `id_empleado` | INT | FK → `empleado`, ON UPDATE CASCADE |
| `id_socio` | INT | FK → `socio`, ON UPDATE CASCADE |

### Multa

Multas generadas por devoluciones tardías.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_multa` | INT IDENTITY | PK |
| `fecha_multa` | DATE | NOT NULL |
| `estado` | VARCHAR(15) | NOT NULL, DEFAULT `PENDIENTE`, CHECK `PENDIENTE`/`PAGADO`/`CANCELADO` |
| `monto` | DECIMAL(10,2) | NOT NULL, CHECK `monto > 0` |
| `id_prestamo` | INT | FK → `prestamo`, ON UPDATE CASCADE |

### Ejemplar

Copias físicas de cada libro.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_ejemplar` | INT IDENTITY | PK |
| `estado` | VARCHAR(20) | NOT NULL, DEFAULT `LIBRE`, CHECK `LIBRE`/`PRESTADO`/`RESERVADO`/`FUERA_SERVICIO` |
| `id_libro` | INT | FK → `libro`, ON UPDATE CASCADE |

### Prestamo_Ejemplar

Relación N:M entre préstamos y ejemplares.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_prestamo` | INT | PK, FK → `prestamo` |
| `id_ejemplar` | INT | PK, FK → `ejemplar` |

### Editorial

Editoriales de los libros.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_editorial` | INT IDENTITY | PK |
| `nombre` | VARCHAR(150) | NOT NULL, UNIQUE |
| `correo` | VARCHAR(150) | NOT NULL, UNIQUE, CHECK contiene `@` |
| `telefono` | VARCHAR(20) | NOT NULL, CHECK solo dígitos, `+`, espacio y `-` |
| `direccion` | VARCHAR(250) | NOT NULL |

### Libro_Editorial

Relación N:M entre libros y editoriales.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_libro` | INT | PK, FK → `libro` |
| `id_editorial` | INT | PK, FK → `editorial` |

### Autor

Autores de las obras.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_autor` | INT IDENTITY | PK |
| `nombre` | VARCHAR(100) | NOT NULL |
| `apellido` | VARCHAR(100) | NOT NULL |
| `fecha_nacimiento` | DATE | NOT NULL |
| `sexo` | CHAR(1) | NOT NULL, CHECK `M`/`F` |

### Genero

Géneros literarios.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_genero` | INT IDENTITY | PK |
| `nombre` | VARCHAR(150) | NOT NULL, UNIQUE |

### Libro_Genero

Relación N:M entre libros y géneros.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_genero` | INT | PK, FK → `genero` |
| `id_libro` | INT | PK, FK → `libro` |

### Libro_Autor

Relación N:M entre libros y autores.

| Columna | Tipo | Restricciones |
| --- | --- | --- |
| `id_libro` | INT | PK, FK → `libro` |
| `id_autor` | INT | PK, FK → `autor` |

## Triggers

| Trigger | Tabla | Descripción |
| --- | --- | --- |
| `trg_prestamo_estado_fechas` | `prestamo` | Valida coherencia de fechas y estado: `fecha_limite` no anterior al préstamo, devolución no futura, `ACTIVO` sin devolución, `ATRASADO` con devolución tardía y `DEVUELTO` a tiempo. |
| `trg_prestamo_multa` | `prestamo` | Al quedar un préstamo en estado `ATRASADO`, genera automáticamente una multa `PENDIENTE` con monto de **2.50 por día de retraso** (si no existe ya una multa para ese préstamo). |
| `trg_prestamo_max_activos` | `prestamo` | Impide que un socio tenga más de **3 préstamos** en estado `ACTIVO`. |
| `trg_prestamo_ejemplar_unico_abierto` | `prestamo_ejemplar` | Impide que un mismo ejemplar esté asociado a más de un préstamo `ACTIVO`. |

## Procedimientos almacenados

| Procedimiento | Parámetros | Descripción |
| --- | --- | --- |
| `usp_prestar_ejemplar` | `@id_socio`, `@id_empleado`, `@id_ejemplar`, `@fecha_limite` (opcional), `@id_prestamo` (OUTPUT) | Registra un préstamo. Valida existencia de socio/empleado/ejemplar, que el ejemplar esté `LIBRE`, que el socio no tenga multas `PENDIENTE` ni más de 3 préstamos activos. Por defecto la fecha límite es de 14 días (máximo 60). Marca el ejemplar como `PRESTADO`. |
| `usp_devolver_prestamo` | `@id_prestamo`, `@fecha_devolucion` (opcional), `@estado`, `@dias_retraso`, `@monto_multa`, `@id_multa` (OUTPUT) | Registra la devolución. Calcula días de retraso y monto, deja el préstamo en `ATRASADO` o `DEVUELTO`, y libera el ejemplar (`LIBRE`) cuando ya no tiene préstamos activos. |
| `usp_pagar_multa` | `@id_multa`, `@estado` (OUTPUT) | Cambia una multa `PENDIENTE` a `PAGADO`. |
| `usp_cancelar_multa` | `@id_multa`, `@estado` (OUTPUT) | Cambia una multa `PENDIENTE` a `CANCELADO`. |

## Datos de prueba

Los CSV de `data/` incluyen cabecera y se cargan respetando las identidades (`KEEPIDENTITY`).

| Tabla | Archivo | Filas |
| --- | --- | ---: |
| `empleado` | `empleado.csv` | 5 000 |
| `socio` | `socio.csv` | 8 000 |
| `editorial` | `editorial.csv` | 600 |
| `autor` | `autor.csv` | 1 000 |
| `genero` | `genero.csv` | 300 |
| `libro` | `libro.csv` | 2 000 |
| `libro_autor` | `libro_autor.csv` | 1 000 |
| `libro_editorial` | `libro_editorial.csv` | 2 000 |
| `libro_genero` | `libro_genero.csv` | 2 000 |
| `prestamo` | `prestamo.csv` | 30 000 |
| `ejemplar` | `ejemplar.csv` | 8 000 |
| `prestamo_ejemplar` | `prestamo_ejemplar.csv` | 30 000 |
| `multa` | `multa.csv` | 6 015 |

Al final de `utils/upload_data.sql` se ejecuta una consulta que devuelve el **nombre de cada tabla y su cantidad de filas** para verificar la carga.
