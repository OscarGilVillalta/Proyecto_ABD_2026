<p align="center">
  <img alt="SQL Server" src="https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white">
  <img alt="T-SQL" src="https://img.shields.io/badge/T--SQL-0078D4?style=for-the-badge&logo=azuredataexplorer&logoColor=white">
  <img alt="Power BI" src="https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black">
</p>

# Proyecto ABD 2026 — Sistema de Biblioteca

Base de datos relacional para la administración de una biblioteca, implementada en **SQL Server**. El proyecto reúne el esquema, las reglas de negocio mediante triggers y procedimientos almacenados, la seguridad basada en roles, la auditoría, las vistas para Power BI, la carga masiva de datos de prueba y la estrategia de respaldo y recuperación.

La base de datos se denomina **`Biblioteca`** y está organizada por esquemas para separar las áreas funcionales del sistema. En palabras simples: cada área tiene su espacio y todo se mantiene ordenado.

> <span style="color:#1D4ED8">**Sugerencia:**</span> si es tu primera vez en el proyecto, comienza por la estructura y el orden de ejecución; el resto del documento cobra sentido después.

---

## 📁 Estructura del repositorio

```
Proyecto_ABD_2026/
│
├── scripts/                     Scripts de construcción de la base de datos
│   ├── 01_database_creation.sql
│   ├── 02_stored_procedures_and_triggers.sql
│   ├── 03_audit.sql
│   ├── 04_security_role_users.sql
│   ├── 05_server_logins.sql
│   ├── 06_advanced_queries.sql
│   ├── 06_login_user_creation.sql
│   ├── 07_indexes_optimization.sql
│   ├── 07_user_role_assignment.sql
│   └── 08_views_powerbi.sql
│
├── data/                        Datos de prueba en formato CSV
│   └── *.csv
│
├── utils/                       Scripts de apoyo
│   ├── upload_data.sql
│   └── useful_queries.sql
│
├── backup/                      Respaldos y estrategia de recuperación
│   ├── Biblioteca.bak
│   ├── Biblioteca_20261110.bak
│   ├── restore.sql
│   └── estrategia/
│       ├── README.md
│       ├── NOTA_SOBRE_BAK_Y_JOBS.md
│       └── scripts/
│           ├── 01_configuracion.sql
│           ├── 02_job_full.sql
│           ├── 03_job_differential.sql
│           ├── 04_job_log.sql
│           └── 05_restauracion.sql
│
├── README.md
├── temp.sql                     Archivo temporal (excluido por .gitignore)
└── .gitignore
```

---

## 📂 Descripción de las carpetas

### `scripts/`

Contiene los scripts que construyen la base de datos. El orden de ejecución es relevante: cada script prepara el terreno para el siguiente.

| Archivo | Descripción |
| --- | --- |
| `01_database_creation.sql` | Crea la base `Biblioteca`, los cinco esquemas y todas las tablas con sus llaves primarias, llaves foráneas y restricciones `CHECK` y `UNIQUE`. |
| `02_stored_procedures_and_triggers.sql` | Crea el trigger de generación de multas por retraso y el procedimiento almacenado para procesar préstamos. |
| `03_audit.sql` | Configura la auditoría del servidor (`Audit_Biblioteca`) y la especificación de auditoría de la base de datos. |
| `04_security_role_users.sql` | Crea los once roles, asigna sus permisos y verifica la existencia de los usuarios. |
| `05_server_logins.sql` | Crea los logins del servidor y los vincula con la base de datos. |
| `06_advanced_queries.sql` | Consultas avanzadas de ejemplo: ranking de libros, meses con mayor cantidad de préstamos, socios con multas, entre otras. |
| `06_login_user_creation.sql` | Alternativa para crear logins asociados a los roles del sistema. |
| `07_indexes_optimization.sql` | Define los índices orientados a optimizar las consultas de reportes. |
| `07_user_role_assignment.sql` | Asigna cada usuario al rol correspondiente. |
| `08_views_powerbi.sql` | Define las vistas destinadas a los reportes de Power BI. |

> <span style="color:#B45309">**Importante:**</span> `04_security_role_users.sql` requiere que los logins de `05_server_logins.sql` existan previamente.

## 🚀 Orden de ejecución

Para levantar el proyecto desde cero, se recomienda seguir esta secuencia:

1. `scripts/01_database_creation.sql` — crea la base de datos y el esquema.
2. `scripts/02_stored_procedures_and_triggers.sql` — crea el trigger y el procedimiento almacenado.
3. `scripts/03_audit.sql` — configura la auditoría.
4. `scripts/05_server_logins.sql` — crea los logins del servidor.
5. `scripts/04_security_role_users.sql` — crea los roles, permisos y usuarios.
6. `scripts/07_user_role_assignment.sql` — asigna los usuarios a los roles.
7. `scripts/07_indexes_optimization.sql` — crea los índices.
8. `scripts/08_views_powerbi.sql` — crea las vistas para reportes.
9. Copiar la carpeta `data/` al contenedor y ejecutar `utils/upload_data.sql`.

La carga masiva utiliza rutas del contenedor (`/data/data/<tabla>.csv`). Las instrucciones detalladas están documentadas al inicio de `utils/upload_data.sql`.

> <span style="color:#0B6E4F">**Consejo:**</span> ejecutar los scripts en otro orden suele terminar en un mensaje de error de dependencias. La secuencia anterior evita ese desvío.

## 📊 Vistas para Power BI

Definidas en `scripts/08_views_powerbi.sql`:

| Vista | Descripción |
| --- | --- |
| `vw_TendenciaMensual` | Cantidad de préstamos por mes y año. |
| `vw_TendenciaYAcumuladoMensual` | Tendencia mensual con acumulado anual. |
| `vw_Top3LibrosPorGenero` | Los tres libros más prestados por género. |
| `vw_ClasificacionSocios` | Clasificación de socios según su actividad. |
| `vw_PrestamosPorEmpleadoPivot` | Préstamos por empleado en formato pivot. |

---

## 🔐 Seguridad

`scripts/04_security_role_users.sql` crea once roles con permisos separados por área:

`rol_bibliotecario`, `rol_usuario_biblioteca`, `rol_programador`, `rol_seguridad`, `rol_gestor_multas`, `rol_gestor_prestamos`, `rol_gestor_socios`, `rol_gestor_rrhh`, `rol_analista`, `rol_profesor` y `rol_backup`.

Los logins se crean en `05_server_logins.sql` (usuarios nominales) o en `06_login_user_creation.sql` (logins genéricos por rol).

> <span style="color:#B45309">**Importante:**</span> las contraseñas incluidas en los scripts son provisionales y deben reemplazarse por credenciales seguras antes de ejecutarlos en un entorno real.

---

## 🕵️ Auditoría

`scripts/03_audit.sql` configura `Audit_Biblioteca`, una auditoría a nivel de servidor que registra los eventos en archivos dentro del directorio `/audit/`. La especificación de auditoría de la base de datos registra las operaciones `INSERT`, `UPDATE` y `DELETE` sobre las tablas `prestamos.prestamo`, `socios.multa` y `socios.socio`, así como la ejecución de `operaciones.sp_procesar_prestamo`.

---

## 🧪 Datos de prueba

Los archivos CSV de `data/` incluyen cabecera y se cargan respetando las identidades mediante `KEEPIDENTITY`.

| Tabla | Archivo | Filas |
| --- | --- | ---: |
| `rrhh.empleado` | `empleado.csv` | 5 000 |
| `socios.socio` | `socio.csv` | 8 000 |
| `catalogo.editorial` | `editorial.csv` | 600 |
| `catalogo.autor` | `autor.csv` | 1 000 |
| `catalogo.genero` | `genero.csv` | 300 |
| `catalogo.libro` | `libro.csv` | 2 000 |
| `catalogo.libro_autor` | `libro_autor.csv` | 1 000 |
| `catalogo.libro_editorial` | `libro_editorial.csv` | 2 000 |
| `catalogo.libro_genero` | `libro_genero.csv` | 2 000 |
| `prestamos.prestamo` | `prestamo.csv` | 30 000 |
| `catalogo.ejemplar` | `ejemplar.csv` | 8 000 |
| `prestamos.prestamo_ejemplar` | `prestamo_ejemplar.csv` | 30 000 |
| `socios.multa` | `multa.csv` | 6 015 |

Al final de `utils/upload_data.sql` se ejecuta una consulta que devuelve el nombre de cada tabla y su cantidad de filas para verificar la carga.

---

## 💾 Respaldos

La carpeta `backup/` contiene los archivos `.bak` de referencia y `restore.sql` para la restauración. La estrategia automática se encuentra en `backup/estrategia/` y utiliza **SQL Server Agent** con la siguiente programación:

- Respaldo **FULL**: diario a las 00:00.
- Respaldo **DIFFERENTIAL**: a las 06:00, 12:00 y 18:00.
- Respaldo **LOG**: cada 15 minutos.

Los archivos se almacenan en `/var/opt/mssql/backup/{full,differential,log}`.

Los respaldos incluyen los objetos propios de la base de datos (esquema, datos, usuarios y roles de base, y la especificación de auditoría). No incluyen objetos de nivel de servidor, como los logins, los Jobs de SQL Server Agent ni la auditoría de servidor. Por lo tanto, al restaurar la base en otra instancia es necesario recrear dichos objetos con los scripts correspondientes y remapear los usuarios para evitar usuarios huérfanos.

> <span style="color:#1D4ED8">**Recordatorio:**</span> los archivos `.bak` y los Jobs viven en el servidor. Al clonar el repositorio en otra máquina, la base se restaura, pero los Jobs deben configurarse de nuevo.