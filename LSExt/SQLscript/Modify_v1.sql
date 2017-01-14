use lansweeperdb;

-- ��� ��������� 08.01.2017 
-- ������� 3 ������� rSclad1C, rScladOriginal, rScladAnalog
-- ������ ������� ������������ ����� ��������� ������������ ������� rSclad � ����� �� ������
-- r1CSprav, rMaterialOriginal, rMaterialAnalog
-- ������ �� ������ ������� �� 4� ��������
-- Id, IdSclad, IdXXXXXX, Number
-- ��� ������� ����� ��������������� �������� ������� �������

-- �������� ���������� �������� � ���� ��������
-- ������, �����������, ������

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ��� ������������ 1� �� �������
Create table rSclad1C 
(
	[Id] int not null identity(1,1) primary key,
	[IdSclad] int not null,
	Constraint FK_rSclad1C_rSclad_IdSclad foreign key (IdSclad)
		references rSclad(Id),
	[Id1CSprav] int not null,
	Constraint FK_rSclad1C_r1CSprav_Id1CSprav foreign key (Id1CSprav)
		references r1CSprav(Id),
	
	[Total] int not null default 0
)

-- ��� ������������ ������ �� �������
Create table rScladAnalog
(
	[Id] int not null identity(1,1) primary key,
	[IdSclad] int not null,
	Constraint FK_rScladAnalog_rSclad_IdSclad foreign key (IdSclad)
		references rSclad(Id),
	[IdMaterialAnalog] int not null,
	Constraint FK_rScladAnalog_rMaterialAnalog_IdMaterialAnalog foreign key (IdMaterialAnalog)
		references rMaterialAnalog(Id),

	[Total] int not null default 0
)

-- ��� ������������ Original �� �������
Create table rScladOriginal
(
	[Id] int not null identity(1,1) primary key,
	[IdSclad] int not null,
	Constraint FK_rScladOriginal_rSclad_IdSclad foreign key (IdSclad)
		references rSclad(Id),
	[IdMaterialOriginal] int not null,
	Constraint FK_rScladOriginal_rMaterialOriginal_IdMaterialOriginal foreign key (IdMaterialOriginal)
		references rMaterialOriginal(Id),

	[Total] int not null default 0
)

----------- ��������� �������� ������� ����� ������������ ���������� ���� ������ ------------------

