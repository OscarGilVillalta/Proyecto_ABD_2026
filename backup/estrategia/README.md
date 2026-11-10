# Estrategia de respaldo y recuperación - Biblioteca

## Contenido

- `scripts/01_configuracion.sql`: comprueba/solicita la creación de los directorios de respaldo.
- `scripts/02_job_full.sql`: crea el Job de respaldo FULL diario.
- `scripts/03_job_differential.sql`: crea el Job de respaldo diferencial tres veces al día.
- `scripts/04_job_log.sql`: crea el Job de respaldo del log cada 15 minutos.
- `scripts/05_restauracion.sql`: plantilla comentada para restaurar una cadena FULL + DIFFERENTIAL + LOG.

## Requisitos previos

1. SQL Server Agent debe estar instalado e iniciado.
2. Ejecutar los scripts con una cuenta `sysadmin`.
3. Debe existir la base `Biblioteca`.
4. `Biblioteca` debe usar el modelo de recuperación `FULL` para respaldos del log.
5. La cuenta del servicio SQL Server debe poder escribir en:
   - `/var/opt/mssql/backup/full`
   - `/var/opt/mssql/backup/differential`
   - `/var/opt/mssql/backup/log`

## Orden de ejecución

Ejecutar en SQL Server Management Studio, en este orden:

1. `01_configuracion.sql`
2. `02_job_full.sql`
3. `03_job_differential.sql`
4. `04_job_log.sql`

Ejecutar primero un respaldo FULL exitoso antes de depender de los respaldos diferenciales y del log. El script `05_restauracion.sql` es una plantilla: leerla y reemplazar rutas y nombres lógicos antes de ejecutar cualquier instrucción de restauración.

## Horarios

Los horarios incluidos están configurados para el entorno del proyecto, donde SQL Server opera en UTC y El Salvador está en UTC-6:

- FULL: 00:00 hora de El Salvador (06:00 UTC).
- DIFFERENTIAL: 06:00, 12:00 y 18:00 hora de El Salvador (12:00, 18:00 y 00:00 UTC).
- LOG: cada 15 minutos, desde las 00:05 hasta las 23:50 UTC.

Si el servidor usa otra zona horaria, ajustar los horarios de los schedules.

## Convención de nombres

Los archivos se generan con fecha y hora:

- `Biblioteca_FULL_YYYYMMDD_HHMMSS.bak`
- `Biblioteca_DIFF_YYYYMMDD_HHMMSS.bak`
- `Biblioteca_LOG_YYYYMMDD_HHMMSS.trn`

Los respaldos usan `COMPRESSION` y `CHECKSUM`.

## Seguridad y conservación

- No subir respaldos `.bak` o `.trn` con datos personales a un repositorio público.
- Mantener copias fuera del servidor donde reside la base de datos.
- Definir una política de retención y probar periódicamente la restauración.
- No borrar un FULL mientras existan diferenciales o logs que dependan de esa cadena.

## Idempotencia y límites

Los scripts de Jobs comprueban si el Job y los schedules con esos nombres ya existen para no duplicarlos. Si ya existen, no los reemplazan ni actualizan. Si se necesita cambiar su configuración, revisar y modificar el Job/schedule manualmente o retirar conscientemente la configuración anterior.

Estos archivos están preparados a partir de la configuración documentada del proyecto. Antes de usarlos en producción o en otra instancia, revisar rutas, zona horaria, permisos, nombres de base de datos y ejecutar pruebas de respaldo y restauración.
