use lansweeperdb;

go

drop table [dbo].rModelComplect
drop table [dbo].rModelDevice

-- ������� �� ��������� ��������� ���������� � ���������� 
-- ������� ����� ���� ���������� ��, ������� ����� �������������� ��� �������
-- �������� 2 ��������� ������� � ������� �������, ��� ������� ����� �������� ������ ������ ��
Create table rModelComplectStatus
(
	[Id]	Int not null identity(1,1) primary key,
	[Status]	nvarchar(3) not null 
)

-- ������� � �������� ��������� (������ ���� ��������� ������ ���� ��������� � ������������ � ���� ��������)
CREATE TABLE [dbo].rModelDevice
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Model] NVARCHAR(255) NOT NULL,
		Constraint AK_Model UNIQUE(Model),
	[IdManufacturer] INT,
		Constraint FK_rManufacturer_rModelDevice_IdManufacturer FOREIGN KEY (IdManufacturer)
			References rManufacturer (Id)
);

-- ��������� ���������� �� �����������
-- ��������� ������� ����� ���� ��������� � �����������.
-- ��� ������� ������������ ��� ���������� ������� �� ���������� (������ ����� ���� �������� ������ � ��� ������ ���� �� �������� �������� 
-- ������������� ���������� ��������� ������� ������ � �������� ��� ����� ����������)
CREATE TABLE [dbo].rModelComplect
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[IdModel] INT NOT NULL,
		Constraint FK_rModelDevice_rModelComplect_Id FOREIGN KEY (IdModel)
			References rModelDevice (Id),
	[IdMaterialOriginal] INT NOT NULL,
		Constraint FK_rMaterialOriginal_rModelComplect_Id FOREIGN KEY (IdMaterialOriginal)
			References rMaterialOriginal (Id),
	[IdStatus] Int Not Null default 1,
		Constraint FK_rModelComplect_rModelComplectStatus_IdStatus foreign key (IdStatus)
			references rModelComplectStatus(Id)
);



