use lansweeperdb;

go

/*
	��������� ���������� �����������
	1 - ����������� ������
	2 - ����������� ���������
*/

if object_id (N'rDvigLKStatus') is null
begin;
	CREATE TABLE [dbo].rDvigLKStatus
	(
		[Id] INT NOT NULL PRIMARY KEY,	
		
		-- ������ ���������� 
		[StatusName] nvarchar(20) not null
	);
end;

insert into rDvigLKStatus (Id, StatusName) Values (1, N'�����');
insert into rDvigLKStatus (Id, StatusName) Values (2, N'�����');
