use lansweeperdb;

go

/*
	�������� ��������, �� ������� tblSoftwareUni softwareName �� ������ 
	� ��������� � rCatalogUslug
*/

if object_id (N'rCatalogProg') is null
begin;
	CREATE TABLE [dbo].rCatalogProg
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- �������� ������� �������� ��������
		[softwareName] NVARCHAR(255) NOT NULL, 
		Constraint AK_rCatalogProg_softwareName Unique(softwareName),
		-- ��������� ������ �� �������� ����� 
		[IdCatalogUslug] int null,
		Constraint FK_rCatalogProg_rCatalogUslug_IdCatalogUslug_Id foreign key (IdCatalogUslug)
			references dbo.rCatalogUslug (Id)
	);
end;

-- ��������� ������� CatalogUslugId
if not exists (
			select * 
			from sys.columns 
			where name = N'IdCatalogUslug')
	begin;
		Alter table rCatalogProg add IdCatalogUslug int Null;
	end;

-- ��������� Constraint 
Alter table rCatalogProg add Constraint FK_rCatalogProg_rCatalogUslug_IdCatalogUslug_Id foreign key (IdCatalogUslug)
			references dbo.rCatalogUslug (Id);




