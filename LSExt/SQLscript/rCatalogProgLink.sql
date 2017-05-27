
use lansweeperdb;

go

/*
	Привязка система и программ
	Такая система привязки систем и программ не корректно
	Одна программа должна однозначно идентифицировать систему и эту систему необходимо обслуживать
	Поэтому rCatalogProg переделываем:
		Добавляем idCatalogUslug
*/

if object_id (N'rCatalogProgLink') is null
begin;
	CREATE TABLE [dbo].rCatalogProgLink
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- название системы из rCatalagUslug
		[nameId] int not null
		Constraint FK_rCatalogProgLink_rCatalogUslug_nameId_Id foreign key (nameId)
			references dbo.rCatalogUslug (Id),
		-- название позиции каталога программ
		[softwareNameId]  int NOT NULL, 
		Constraint FK_rCatalogProgLink_rCatalogProg_softwareNameId_Id foreign key (softwareNameId)
			references dbo.rCatalogProg (Id)
	);
end;

-- добавляем индекс программа может входить только в одну систему услуг
if exists (select name from sys.indexes
			where name = N'IX_rCatalogProgLink_nameId_softwareNameId')
	begin;
		drop index IX_rCatalogProgLink_nameId_softwareNameId on rCatalogProgLink

		Create unique index IX_rCatalogProgLink_nameId_softwareNameId
		on dbo.rCatalogProgLink (nameId, softwareNameId)
	end;
else
	begin;
		Create unique index IX_rCatalogProgLink_nameId_softwareNameId
		on dbo.rCatalogProgLink (nameId, softwareNameId)
	end;




