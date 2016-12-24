use lansweeperdb;

go 

-- ������� ������� � ��������������� ��������� � ��������� ����������
CREATE TABLE [dbo].rManufacturer
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[FullName] NVARCHAR(255),
	[ShortName] NVARCHAR(100) NOT NULL,	-- ������� ��� ��� ���� ������ ��������� ������ ���������� ��������
	Constraint AK_ShortName UNIQUE(ShortName)
);

-- ���������� 
-- ������� ������� � �������� ���������, ������� ��� ���������,
-- ���������� ���������� �������� �����, ������� ��� �����
CREATE TABLE [dbo].rDevice
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Type] NVARCHAR(100) NULL,
	[Manufacturer] NVARCHAR(100) NOT NULL,
	[PartNumber] NVARCHAR(100) NOT NULL,	-- ������� ��� ��� ���� ������ ��������� ������ ���������� ��������
	Constraint AK_PartNumber UNIQUE(PartNumber),
	[Name] NVARCHAR(255) Not NULL, 

	-- ���� ������� ����� � �������� rManufacturer �� ���� ShortName
	Constraint FK_rManufacturer_ShortName FOREIGN KEY (Manufacturer)
		References rManufacturer (ShortName)
		on UPDATE CASCADE
);

-- ����������
-- ������� ������� � ������������� ���������� ����������� ���������� �����������
-- ��� �������� ������ � ���� ������� ������������� ������ ����������� ������ � ������� rRashodMaterial 
-- ����� ����������� ������ ����� ���� ��������� ��� ������������ �������
CREATE TABLE [dbo].rRashodMaterialOriginal
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Manufacturer] NVARCHAR(100) NOT NULL,
	[PartNumber] NVARCHAR(100) NOT NULL,	-- ������� ��� ��� ���� ������ ��������� ������ ���������� ��������
	Constraint AK_PartNumber UNIQUE(PartNumber),
	[Type] NVARCHAR(100) NULL,
	[Name] NVARCHAR(255) Not NULL, 
	[Resource] INT NULL,			-- ������ ���������� ��������� ���.
	[Comment] NVARCHAr(255) NULL

	-- ���� ������� ����� � �������� rManufacturer �� ���� ShortName
	Constraint FK_rManufacturer_ShortName FOREIGN KEY (Manufacturer)
		References rManufacturer (ShortName)
		on UPDATE CASCADE
);


-- ���������� 
-- ������� ������� �� ������� �������� <-> ����������
-- ���� �������� ����� ���� �������� ���������� �����������
CREATE TABLE [dbo].rLinkDeviceToRMOrig
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[DevicePartNumber] NVARCHAR(100) NOT NULL,
	[RMPartNumber] NVARCHAR(100) NOT NULL,

	Constraint FK_rDevice_PartNumber FOREIGN KEY (DevicePartNumber)
		References rDevice (PartNumber),

	Constraint FK_rRashodMaterialOriginal_PartNumber FOREIGN KEY (RMPartNumber)
		References rRashodMaterialOriginal (PartNumber),

	Constraint FK_rDevice_rRM UNIQUE( DevicePartNumber, RMPartNumber)

);

-- ������� ������� � ���������� �����������, ������� �� ����� ������������� �� ����������
CREATE TABLE [dbo].rRashodMaterial
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Manufacturer] NVARCHAR(100) NOT NULL,
	[PartNumber] NVARCHAR(100) NOT NULL,	-- ������� ��� ��� ���� ������ ��������� ������ ���������� ��������
	[Type] NVARCHAR(100) NULL,
	[PartNumberOriginal] NVARCHAR(255) Not NULL,
	Constraint AK_PartNumber UNIQUE(PartNumber),
	[Name] NVARCHAR(255) Not NULL, 
	[Resource] INT NULL,			-- ������ ���������� ��������� ���.
	[Comment] NVARCHAr(255) NULL

	-- ���� ������� ����� � �������� rManufacturer �� ���� ShortName
	Constraint FK_rManufacturer_ShortName FOREIGN KEY (Manufacturer)
		References rManufacturer (ShortName)
		on UPDATE CASCADE

	Constraint FK_rRashodMaterialOriginal_PartNumber FOREIGN KEY (PartNumberOriginal)
		References rRashodMaterialOriginal (PartNumber)
		on UPDATE CASCADE
);

-- ������� ������� ����������� ������ ���������� �� �����������
CREATE TABLE [dbo].rTechObslug
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[AssetId] INT NOT NULL,
	[PartNumber] NVARCHAR(100) NOT NULL,
	[PrintedPages] INT NOT NULL, 
	[Date] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,

	-- ���� ������� ����� � tblAssetCustom
	Constraint FK_tblAssetCustom_AssetID FOREIGN KEY (AssetId)
		References tblAssetCustom (AssetId),
	-- ���� ������� ����� � rRashoMaterial �� ���� �������
	Constraint FK_rRashodMaterial_PartNumber FOREIGN KEY (PartNumber)
		References rRashodMaterial (PartNumber)
);


-- ������� ������� ����������� ������ ���������� �� �����������
CREATE TABLE [dbo].rZayavkaOborud
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Type] nvarchar(100) NOT NULL,
	[idrPersonal] int NULL,
	[idrShtatR] INT NOT NULL, 
	[Comments] nvarchar(255) NULL,
	[Document] nvarchar(400) NOT NULL

	-- ���� ������� ����� � rShtatR
	Constraint FK_rShtatR_ID FOREIGN KEY (idrShtatR)
		References rShtatR (id),
);



