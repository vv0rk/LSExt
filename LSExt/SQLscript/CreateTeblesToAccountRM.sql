use lansweeperdb;

go 

-- ������� ������� � ������������ ��� ������������ ������
CREATE TABLE [dbo].rDvicesList
(
	[DeviceName] NVARCHAR(100) NOT NULL PRIMARY KEY,
	[Comment] NVARchar(255) NULL	-- ����������� �������� ������� ������� ��� ������� ����������� ������ �� ������������
);



-- ������� ������� � �������� ����������� �� �������������
CREATE TABLE [dbo].rZayavka
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[DeviceList] NVARCHAR(100) NOT NULL,
	[idrShtatR] INT NOT NULL,	-- ����������� �������� ������� ������� ��� ������� ����������� ������ �� ������������
	[Comment] nvarchar(255) NULL,
	[Gorod] nvarchar(100) Null,
	[Address] nvarchar(255) NULL, 
	[Office] nvarchar(100) NULL,
	[LinkSource] NVARCHAR(500) NOT NULL
);

CREATE TABLE [dbo].rSpec
(
	[Id] INT NOT NULL Identity(1,1) PRImary key,
	[idrZayavka] INT NOT NULL,
	[Spec] NVARCHAR(500) NOT NULL,
	[LinkSpec] NVARCHAR(500) NOT NULL,

	-- ������ ������ �� �������������
	Constraint FK_rZayavka_rSpec Foreign Key (idrZayavka)
	References rZayavka (Id),
);

CREATE TABLE [dbo].rZakupka
(
	[Id] INT NOT NULL Identity(1,1) PRImary key,
	[idrSpec] INT NOT NULL,
	[DateStart] Datetime default CURRENT_TIMESTAMP not null,
	[Spec] NVARCHAR(500) NOT NULL,
	[LinkSpec] NVARCHAR(500) NOT NULL,
	[LinkDoc] nvarchar(500) null,

	-- ������ ������ �� �������������
	Constraint FK_rZakupka_rSpec Foreign Key (idrSpec)
	References rSpec (Id),
);


-- ���������� ������ 
CREATE TABLE [dbo].rGorod
(
	[Id] INT NOT NULL Identity(1,1) PRImary key,
	[Gorod] NVARCHAR(100) NOT NULL,

	-- ������ ������ �� �������������
	Constraint AK_rGorod_Gorod Unique(Gorod)
);

