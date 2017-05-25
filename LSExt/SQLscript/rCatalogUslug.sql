
use lansweeperdb;

go

/*
	перечень услуг из каталога услуг, то что мы предоставл€ем «аказчикам
*/

if object_id (N'rCatalogUslug') is null
begin;
	CREATE TABLE [dbo].rCatalogUslug
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- название позиции каталога услуг
		[Name] NVARCHAR(255) NOT NULL, 
		Constraint AK_rCatalogUslug_Name Unique(Name),
		[StatusId] int default 1 not null,
		Constraint FK_rCatalogUslug_rCatalogUslugStatus_StatusId_Id foreign key (StatusId)
			references dbo.rCatalogUslugStatus (Id)
	);
end;

-- добавл€ем столбец StatusId
if not exists (
			select * 
			from sys.columns 
			where name = N'StatusId')
	begin;
		Alter table rCatalogUslug add StatusId int default 1 not Null;
	end;

-- добавл€ем Constraint 
Alter table rCatalogUslug add Constraint FK_rCatalogUslug_rCatalogUslugStatus_StatusId_Id foreign key (StatusId)
			references dbo.rCatalogUslugStatus (Id);
