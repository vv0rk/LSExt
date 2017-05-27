use lansweeperdb;

go

/*
	перечень программ, из таблицы tblSoftwareUni softwareName по именам 
	и связанные с rCatalogUslug
*/

if object_id (N'rCatalogProg') is null
begin;
	CREATE TABLE [dbo].rCatalogProg
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- название позиции каталога программ
		[softwareName] NVARCHAR(255) NOT NULL, 
		Constraint AK_rCatalogProg_softwareName Unique(softwareName),
		-- добавляем индекс от каталога услуг 
		[IdCatalogUslug] int null,
		Constraint FK_rCatalogProg_rCatalogUslug_IdCatalogUslug_Id foreign key (IdCatalogUslug)
			references dbo.rCatalogUslug (Id)
	);
end;

-- добавляем столбец CatalogUslugId
if not exists (
			select * 
			from sys.columns 
			where name = N'IdCatalogUslug')
	begin;
		Alter table rCatalogProg add IdCatalogUslug int Null;
	end;

-- добавляем Constraint 
Alter table rCatalogProg add Constraint FK_rCatalogProg_rCatalogUslug_IdCatalogUslug_Id foreign key (IdCatalogUslug)
			references dbo.rCatalogUslug (Id);




