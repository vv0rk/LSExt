use lansweeperdb;

go

/*
	������ �������� ��� ��������, ������� ������������ 
	������ �������� ����� ����, ������ �����, ����� �� ������� ���
*/

if object_id (N'rDvigLK') is null
begin;
	CREATE TABLE [dbo].rDvigLK
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		[idEmployee] int not null,
		Constraint FK_rDvigLK_rEmployeeMod_idEmployee_Id foreign key (idEmployee)
			references dbo.rEmployeeMod (id),
		-- �������� ����� 0 - �� ��������, 1 - ��������
		[isApproved] bit not null default 0,
		-- ���
		[idmol] int not null,
		Constraint FK_rDvigLK_rEmployeeMod_idmol_id foreign key (idmol)
			references dbo.rEmployeeMod (id),

		-- ������ �� ���������� ������ ��������, ���� ����
		[idprev] int null, 
		-- ��� ���������, �������� ��� ����� ������ ��������, ������ � �������, 
		-- [idType] int not null 

	);
end;

