# Nota sobre archivos .bak y SQL Server Agent

Este directorio contiene scripts para configurar Jobs y una plantilla de restauración. No incluye archivos de respaldo de la base de datos.

Los archivos `.bak` y `.trn` pueden contener datos personales (por ejemplo, nombres, DUI y fechas de nacimiento). No deben publicarse en un repositorio público. Compartirlos únicamente si el repositorio es privado y el equipo/profesor autoriza expresamente su inclusión.

Los Jobs existentes en una instancia no se transfieren al clonar el repositorio: se recrean ejecutando los scripts SQL en esa instancia. Los historiales de ejecución y los archivos de respaldo tampoco forman parte del repositorio.
