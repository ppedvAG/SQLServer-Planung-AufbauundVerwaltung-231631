create database anwendungsrolleDB
Go

USE anwendungsrolleDB
GO

Create table test (id int);
GO

Insert into test values (1),(2),(3)




--Windows KOnto oder Gruppe
USE [master]
GO
CREATE LOGIN [EARTH\jb1] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
USE anwendungsrolleDB
GO
CREATE USER [EARTH\jb1] FOR LOGIN [EARTH\jb1]
GO

--Anlegen der Anwendungsrolle
USE anwendungsrolleDB
GO
CREATE APPLICATION ROLE [Gehaltsrolle] 
	WITH DEFAULT_SCHEMA = [dbo], PASSWORD = N'ppedv2014!'
GO

--Nun der Anwendungsrolle Rechte geben
use [anwendungsrolleDB]
GO
GRANT SELECT ON [dbo].[test] TO [Gehaltsrolle]
GO


--Achtung: Bis hierhin kann der Windowsuser JB1 nichts in Northwind

execute as user='EARTH\jb1'
select * from test

--nun der Code, der in Anwendung ausgeführt werden muss

exec sp_setapprole 'Gehaltsrolle', 'ppedv2014!' 
	-- Das Kennwort kann verschlüsselt übertragen werden
	--Die Anwendung holt sich das Kennwort evtl aus dem Code heraus oder Registry, XML oder ini-file

select * from test
select SUSER_NAME()



