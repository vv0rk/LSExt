use lansweeperdb;

go

/*
	��� �� ������ ������ �������� ��� ������ ���������
	�� ���� ������� �������� �������������.
	�������� ������� �� � ������� �������� ������������ ������ ��� ������� ��������������� ���������.
	��� ��������� ������������ ����� (idType): ����� ���� ������ ���������, ����������� �������, �������� ������� ...
	��� ������� ��������� ��������� ���� ������ ��������������� ��������� � ������ � ���� ����������� ������� ����� ����������� ���������.
	������ �������� ��� ��������, ������� ������������ 
	������ �������� ����� ����, ������ �����, ����� �� ������� ���
*/

if object_id (N'rDvigLK') is null
begin;
	CREATE TABLE [dbo].rDvigLK
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,	
		
		-- ��� ���������: ������ ��������, ����������� �����, ����������� �����
		[idType] int not null,
		Constraint FK_rDvigLK_rDvigLKType_idType_Id foreign key (idType)
			references dbo.rDvigLKType (Id),
		-- ������������� �� ��� ���������, ������������� ������������ �� rEmployee
		[idResponce] bigint not null,
		Constraint FK_rDvigLK_rEmployee_idResponce_Id foreign key (idResponce)
			references dbo.rEmployee (id),

		-- ����������� ������� ����������� ������ ���������
		[idCompany] int not null,
		Constraint FK_rDvigLK_rCompany_idCompany_id foreign key (idCompany)
			references dbo.rCompany$ (id),

		[Gorod] nvarchar(255) null,
		[Adress] nvarchar(255) null,
		[Office] nvarchar(255) null
		
	);
end;

