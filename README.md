# 📚 Proyecto ABD 2026 — Sistema de Biblioteca 🏛️

Base de datos relacional para administrar una biblioteca, hecha en **SQL Server**. Aquí vive todo: el esquema, los triggers, el procedimiento de préstamos, la seguridad por roles, la auditoría, las vistas para Power BI y los respaldos automáticos. 😎

> La base se llama **`Biblioteca`** y está organizada por esquemas para no volverse un caos. 🧹

---

## 🗺️ Estructura general

```
Proyecto_ABD_2026/
│
├── 📂 scripts/                  → Todo el SQL que construye la base
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
├── 📂 data/                     → Los CSV con los datos de prueba
│   └── *.csv
│
├── 📂 utils/                    → Scripts de apoyo
│   ├── upload_data.sql
│   └── useful_queries.sql
│
├── 📂 backup/                   → Respaldos y estrategia de recuperación
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
├── 📄 README.md                 → Estás aquí 👋
├── 📄 temp.sql                  → Archivo temporal (ignorado por git)
└── 📄 .gitignore
```

---

## 📁 ¿Qué hay en cada carpeta?

### 🧩 `scripts/` — El corazón del proyecto

Aquí se construye la base paso a paso. **El orden importa** ⚠️.

| Archivo | ¿Qué hace? |
| --- | --- |
| `01_database_creation.sql` | Crea la base `Biblioteca`, los 5 esquemas y todas las tablas con sus PK, FK, `CHECK` y `UNIQUE`. 🏗️ |
| `02_stored_procedures_and_triggers.sql` | Crea el trigger que genera multas por retraso y el procedimiento que procesa un préstamo. ⚙️ |
| `03_audit.sql` | Configura la auditoría del servidor (`Audit_Biblioteca`) para registrar actividad. 🕵️ |  
| `04_security_role_users.sql` | Crea los 11 roles, les da permisos y verifica que existan los usuarios. 🔐 |
| `05_server_logins.sql` | Crea los logins del servidor y los vincula con la base. 👤 |
| `06_advanced_queries.sql` | Consultas avanzadas de ejemplo: rankings, meses con más préstamos, socios morosos, etc. 📊 |
| `06_login_user_creation.sql` | Alternativa para crear logins de los roles (bibliotecario, analista, usuario, gestor de multas…). 🔑 |
| `07_indexes_optimization.sql` | Índices pensados para acelerar las consultas del reporte. ⚡ |
| `07_user_role_assignment.sql` | Mete a cada usuario dentro de su rol correspondiente. 🎭 |
| `08_views_powerbi.sql` | Vistas listas para conectar Power BI. 📈 |

> 💡 Nota: `04_security_role_users.sql` necesita que primero existan los logins de `05_server_logins.sql`.

### 💾 `data/` — Los datos de prueba

Un CSV por tabla, **con cabecera** y cargados con `KEEPIDENTITY` para respetar los IDs. Aquí no hay joins ni triggers, solo datos listos para explotar la base. 🧪

Tablas con datos: `empleado`, `socio`, `editorial`, `autor`, `genero`, `libro`, `libro_autor`, `libro_editorial`, `libro_genero`, `prestamo`, `ejemplar`, `prestamo_ejemplar` y `multa`.

### 🛠️ `utils/` — Herramientas del día a día

| Archivo | ¿Qué hace? |
| --- | --- |
| `upload_data.sql` | Hace `BULK INSERT` de cada CSV dentro del contenedor y al final muestra cuántas filas quedaron por tabla. 📥 |
| `useful_queries.sql` | Consultas rápidas para revisar esquemas, auditoría y estado del servidor. 🔍 |

### 🗄️ `backup/` — Los respaldos

| Archivo | ¿Qué hace? |
| --- | --- |
| `Biblioteca.bak` | Respaldo completo de la base. 📦 |
| `Biblioteca_20261110.bak` | Respaldo completo con fecha. 📅 |
| `restore.sql` | Comandos para restaurar la base desde un `.bak` con `MOVE` y `REPLACE`. ♻️ |

### 🧯 `backup/estrategia/` — Respaldos automáticos

Aquí está la estrategia de respaldo usando **SQL Server Agent**:

| Archivo | ¿Qué hace? |
| --- | --- |
| `README.md` | Explica horarios, rutas y orden de ejecución de los Jobs. 🗓️ |
| `NOTA_SOBRE_BAK_Y_JOBS.md` | Aclara que los `.bak` y los Jobs viven en el servidor, no en el repo. 📝 |
| `scripts/01_configuracion.sql` | Prepara los directorios de respaldo. 📂 |
| `scripts/02_job_full.sql` | Job de respaldo **completo** (todos los días a las 00:00). 🌕 |
| `scripts/03_job_differential.sql` | Job de respaldo **diferencial** (06:00, 12:00 y 18:00). 🌗 |
| `scripts/04_job_log.sql` | Job de respaldo del **log** cada 15 minutos. ⏱️ |
| `scripts/05_restauracion.sql` | Referencia para recuperar la base desde los respaldos. 🚑 |

---

## 🧱 Esquemas de la base

La base no es un solo bolsón: está separada por áreas para que cada quien viva en su barrio. 🏘️

| Esquema | ¿De qué se encarga? |
| --- | --- |
| `rrhh` | Empleados de la biblioteca. 👔 |
| `socios` | Socios y multas. 🧑‍🤝‍🧑 |
| `catalogo` | Libros, ejemplares, autores, géneros y editoriales. 📖 |
| `prestamos` | Préstamos y su relación con ejemplares. 🔄 |
| `operaciones` | Procedimientos de negocio. 🧠 |

---

## 🚀 Orden de ejecución

Para levantar todo desde cero:

1. **`scripts/01_database_creation.sql`** — crea la base y el esquema. 🏗️
2. **`scripts/02_stored_procedures_and_triggers.sql`** — trigger y procedimiento. ⚙️
3. **`scripts/03_audit.sql`** — auditoría del servidor. 🕵️
4. **`scripts/05_server_logins.sql`** — logins. 👤
5. **`scripts/04_security_role_users.sql`** — roles, permisos y usuarios. 🔐
6. **`scripts/07_user_role_assignment.sql`** — asigna usuarios a roles. 🎭
7. **`scripts/07_indexes_optimization.sql`** — índices. ⚡
8. **`scripts/08_views_powerbi.sql`** — vistas para reportes. 📈
9. Copiar `data/` al contenedor y ejecutar **`utils/upload_data.sql`**. 📥

> 📌 La carga usa rutas del contenedor (`/data/data/<tabla>.csv`). Las instrucciones exactas están comentadas al inicio de `utils/upload_data.sql`.

---

## 📈 Vistas para Power BI

Definidas en `scripts/08_views_powerbi.sql`:

| Vista | ¿Qué muestra? |
| --- | --- |
| `vw_TendenciaMensual` | Cantidad de préstamos por mes y año. 📅 |
| `vw_TendenciaYAcumuladoMensual` | Lo anterior más el acumulado anual. 📊 |
| `vw_Top3LibrosPorGenero` | Los 3 libros más prestados de cada género. 🥇 |
| `vw_ClasificacionSocios` | Clasificación de socios según su actividad. 🏅 |
| `vw_PrestamosPorEmpleadoPivot` | Préstamos por empleado en formato pivot. 👔 |

---

## 🔐 Seguridad

`scripts/04_security_role_users.sql` crea **11 roles** con permisos separados por área:

`rol_bibliotecario`, `rol_usuario_biblioteca`, `rol_programador`, `rol_seguridad`, `rol_gestor_multas`, `rol_gestor_prestamos`, `rol_gestor_socios`, `rol_gestor_rrhh`, `rol_analista`, `rol_profesor` y `rol_backup`. 🛡️

Los logins se crean en `05_server_logins.sql` (usuarios nominales) o en `06_login_user_creation.sql` (logins genéricos por rol). 🔑

---

## 🕵️ Auditoría

`scripts/03_audit.sql` crea `Audit_Biblioteca`, una auditoría a nivel de servidor que guarda los eventos en archivos dentro de `/audit/`. Ideal para saber quién hizo qué y cuándo. 🕵️‍♂️

---

## 🗄️ Respaldos

La carpeta `backup/` guarda los `.bak` de referencia y `restore.sql` para restaurar. La estrategia automática vive en `backup/estrategia/` y usa **SQL Server Agent**:

- 🌕 **FULL** todos los días a las 00:00.
- 🌗 **DIFFERENTIAL** a las 06:00, 12:00 y 18:00.
- ⏱️ **LOG** cada 15 minutos.

Los archivos se guardan en `/var/opt/mssql/backup/{full,differential,log}`. 📦

> ⚠️ Los `.bak` y los Jobs viven en el servidor; si clonas el repo en otra máquina, hay que volver a configurar los Jobs. 😉

---