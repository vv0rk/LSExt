
use lansweeperdb;

go

/*
	�������� ����� �� �������� �����, �� ��� �� ������������� ����������
*/

if object_id (N'rCatalogUslug') is null
begin;
	CREATE TABLE [dbo].rCatalogUslug
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- �������� ������� �������� �����
		[Name] NVARCHAR(255) NOT NULL, 
		Constraint AK_rCatalogUslug_Name Unique(Name),
		[StatusId] int default 1 not null,
		Constraint FK_rCatalogUslug_rCatalogUslugStatus_StatusId_Id foreign key (StatusId)
			references dbo.rCatalogUslugStatus (Id)
	);
end;

-- ��������� ������� StatusId
if not exists (
			select * 
			from sys.columns 
			where name = N'StatusId')
	begin;
		Alter table rCatalogUslug add StatusId int default 1 not Null;
	end;

-- ��������� Constraint 
Alter table rCatalogUslug add Constraint FK_rCatalogUslug_rCatalogUslugStatus_StatusId_Id foreign key (StatusId)
			references dbo.rCatalogUslugStatus (Id);
