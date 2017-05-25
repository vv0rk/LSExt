use lansweeperdb;

go

/*
	перечень программ, из таблицы tblSoftwareUni softwareName по именам 
	и вы
*/

if object_id (N'rCatalogProg') is null
begin;
	CREATE TABLE [dbo].rCatalogProg
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- название позиции каталога программ
		[softwareName] NVARCHAR(255) NOT NULL, 
		Constraint AK_rCatalogProg_softwareName Unique(softwareName)
	);
end;

