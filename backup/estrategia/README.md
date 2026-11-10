# Estrategia de respaldo y recuperación de Biblioteca

Esta carpeta contiene los scripts utilizados para configurar los respaldos de la base de datos Biblioteca mediante SQL Server Agent.

## Archivos

Dentro de la carpeta `scripts` se encuentran los siguientes archivos:

- `01_configuracion.sql`: prepara los directorios donde se almacenarán los respaldos.
- `02_job_full.sql`: configura el respaldo completo de la base de datos.
- `03_job_differential.sql`: configura los respaldos diferenciales.
- `04_job_log.sql`: configura los respaldos del registro de transacciones.
- `05_restauracion.sql`: contiene los comandos de referencia para recuperar la base de datos.

## Configuración

Antes de ejecutar los scripts, se debe comprobar que:

- La base de datos `Biblioteca` esté creada.
- SQL Server Agent se encuentre iniciado.
- El servidor tenga permisos para escribir en los directorios de respaldo.
- La base de datos utilice el modelo de recuperación FULL.

## Orden de ejecución

Los scripts deben ejecutarse desde SQL Server Management Studio en el siguiente orden:

1. `01_configuracion.sql`
2. `02_job_full.sql`
3. `03_job_differential.sql`
4. `04_job_log.sql`

Primero debe realizarse un respaldo completo para establecer la base de la cadena de respaldos.

El archivo `05_restauracion.sql` se utiliza como referencia al momento de recuperar la base de datos. Antes de ejecutarlo, se deben indicar los nombres y las rutas de los archivos de respaldo disponibles.

## Horarios programados

La configuración utilizada para el proyecto establece los siguientes horarios:

- Respaldo FULL: todos los días a las 00:00.
- Respaldo DIFFERENTIAL: todos los días a las 06:00, 12:00 y 18:00.
- Respaldo LOG: cada 15 minutos.

Los horarios están definidos considerando la hora de El Salvador y la diferencia con la hora del servidor SQL Server.

## Almacenamiento

Los archivos se guardan en las siguientes ubicaciones:

- Respaldos completos: `/var/opt/mssql/backup/full`
- Respaldos diferenciales: `/var/opt/mssql/backup/differential`
- Respaldos del log: `/var/opt/mssql/backup/log`

Cada archivo se genera con su fecha y hora para facilitar su identificación.
