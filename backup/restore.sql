use master;
create database Proyecto;

RESTORE FILELISTONLY 
FROM DISK = '/backup/Biblioteca_20261110.bak';

RESTORE DATABASE [Biblioteca]
FROM DISK = N'/backup/Biblioteca_20261110.bak'
WITH 
    MOVE N'Biblioteca' TO N'/var/opt/mssql/data/Biblioteca.mdf',
    MOVE N'Biblioteca_log' TO N'/var/opt/mssql/data/Biblioteca_log.ldf',
    REPLACE, 
    STATS = 10;
GO

use Biblioteca;
go