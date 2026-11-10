# Archivos de respaldo y Jobs

Los archivos de respaldo de la base de datos se generan desde SQL Server y se almacenan en los directorios configurados para cada tipo de respaldo.

Los scripts de esta carpeta permiten crear los Jobs de SQL Server Agent que se encargan de ejecutar los respaldos de forma programada.

Al trabajar desde otro equipo o clonar el repositorio, se deben ejecutar nuevamente los scripts para configurar los Jobs en la instancia de SQL Server correspondiente.

Los archivos de respaldo y el historial de ejecución se mantienen en el servidor y no se generan automáticamente al descargar el proyecto.
