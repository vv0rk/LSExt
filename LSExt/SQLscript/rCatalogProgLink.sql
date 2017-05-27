
use lansweeperdb;

go

/*
	�������� ������� � ��������
	����� ������� �������� ������ � �������� �� ���������
	���� ��������� ������ ���������� ���������������� ������� � ��� ������� ���������� �����������
	������� rCatalogProg ������������:
		��������� idCatalogUslug
*/

if object_id (N'rCatalogProgLink') is null
begin;
	CREATE TABLE [dbo].rCatalogProgLink
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- �������� ������� �� rCatalagUslug
		[nameId] int not null
		Constraint FK_rCatalogProgLink_rCatalogUslug_nameId_Id foreign key (nameId)
			references dbo.rCatalogUslug (Id),
		-- �������� ������� �������� ��������
		[softwareNameId]  int NOT NULL, 
		Constraint FK_rCatalogProgLink_rCatalogProg_softwareNameId_Id foreign key (softwareNameId)
			references dbo.rCatalogProg (Id)
	);
end;

-- ��������� ������ ��������� ����� ������� ������ � ���� ������� �����
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




