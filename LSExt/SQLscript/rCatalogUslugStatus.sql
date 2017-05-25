use lansweeperdb;

go

/*
	������ ���������� ����� �� ��������� ���������� �������������� �� �� ����� ���������
	��������� - �� ����� ���������
	��������� - ���, ��� ����������� ����� ������������� ������ ���������� ��������� �� �����
	������������ � ��������
	������������ ��� ������������ ������ �� ���������� ������������� ����������� (����)
*/

if object_id (N'rCatalogUslugStatus') is null
begin;
	CREATE TABLE [dbo].rCatalogUslugStatus
	(
		[Id] INT NOT NULL PRIMARY KEY,		
		-- �������� ������� �������� ��������
		[Status] NVARCHAR(50) NOT NULL, 
		Constraint AK_rCatalogUslugStatus_Status Unique(Status),
	);
end;

insert into [dbo].rCatalogUslugStatus ( Id, Status ) Values ( 1, N'���������');
insert into [dbo].rCatalogUslugStatus ( Id, Status ) Values ( 2, N'���������');

