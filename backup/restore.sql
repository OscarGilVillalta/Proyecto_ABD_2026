use master;
create database Proyecto;

RESTORE FILELISTONLY 
FROM DISK = '/var/opt/mssql/backup/Biblioteca.bak';

RESTORE DATABASE [Biblioteca]
FROM DISK = N'/var/opt/mssql/backup/Biblioteca.bak'
WITH 
    MOVE N'Proyecto' TO N'/var/opt/mssql/data/Biblioteca.mdf',
    MOVE N'Proyecto_log' TO N'/var/opt/mssql/data/Biblioteca_log.ldf',
    REPLACE, 
    STATS = 10;
GO

use Biblioteca;
go