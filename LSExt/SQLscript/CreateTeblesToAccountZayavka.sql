use lansweeperdb;

go 

-- —оздаем таблицу с производител€ми устройств и расходных материалов
CREATE TABLE [dbo].rManufacturer
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[FullName] NVARCHAR(255),
	[ShortName] NVARCHAR(100) NOT NULL,	-- сделать что это поле должно содержать только уникальные значени€
	Constraint AK_ShortName UNIQUE(ShortName)
);

-- ƒќ–јЅќ“ј“№ 
-- —оздаем таблицу с модел€ми устройств, которые нам интересны,
-- необходимо доработать перечень полей, которые нам нужны
CREATE TABLE [dbo].rDevice
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Type] NVARCHAR(100) NULL,
	[Manufacturer] NVARCHAR(100) NOT NULL,
	[PartNumber] NVARCHAR(100) NOT NULL,	-- сделать что это поле должно содержать только уникальные значени€
	Constraint AK_PartNumber UNIQUE(PartNumber),
	[Name] NVARCHAR(255) Not NULL, 

	-- надо сделать св€зь с таблицей rManufacturer по полю ShortName
	Constraint FK_rManufacturer_ShortName FOREIGN KEY (Manufacturer)
		References rManufacturer (ShortName)
		on UPDATE CASCADE
);

-- ƒќ–јЅќ“ј“№
-- —оздаем таблицу с оригинальными расходными материалами расходными материалами
-- при создании записи в этой таблице автоматически должна создаватьс€ запись в таблице rRashodMaterial 
-- чтобы создаваемый ресурс можно было добавл€ть при фиксировании расхода
CREATE TABLE [dbo].rRashodMaterialOriginal
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Manufacturer] NVARCHAR(100) NOT NULL,
	[PartNumber] NVARCHAR(100) NOT NULL,	-- сделать что это поле должно содержать только уникальные значени€
	Constraint AK_PartNumber UNIQUE(PartNumber),
	[Type] NVARCHAR(100) NULL,
	[Name] NVARCHAR(255) Not NULL, 
	[Resource] INT NULL,			-- ресурс расходного материала стр.
	[Comment] NVARCHAr(255) NULL

	-- надо сделать св€зь с таблицей rManufacturer по полю ShortName
	Constraint FK_rManufacturer_ShortName FOREIGN KEY (Manufacturer)
		References rManufacturer (ShortName)
		on UPDATE CASCADE
);


-- ƒќ–јЅќ“ј“№ 
-- —оздаем таблицу со св€з€ми материал <-> устройство
-- ќдин материал может быть назначен нескольким устройствам
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

-- —оздаем таблицу с расходными материалами, которые мы будем устанавливать на устройства
CREATE TABLE [dbo].rRashodMaterial
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Manufacturer] NVARCHAR(100) NOT NULL,
	[PartNumber] NVARCHAR(100) NOT NULL,	-- сделать что это поле должно содержать только уникальные значени€
	[Type] NVARCHAR(100) NULL,
	[PartNumberOriginal] NVARCHAR(255) Not NULL,
	Constraint AK_PartNumber UNIQUE(PartNumber),
	[Name] NVARCHAR(255) Not NULL, 
	[Resource] INT NULL,			-- ресурс расходного материала стр.
	[Comment] NVARCHAr(255) NULL

	-- надо сделать св€зь с таблицей rManufacturer по полю ShortName
	Constraint FK_rManufacturer_ShortName FOREIGN KEY (Manufacturer)
		References rManufacturer (ShortName)
		on UPDATE CASCADE

	Constraint FK_rRashodMaterialOriginal_PartNumber FOREIGN KEY (PartNumberOriginal)
		References rRashodMaterialOriginal (PartNumber)
		on UPDATE CASCADE
);

-- —оздаем таблицу учитывающую расход материалов на устройствах
CREATE TABLE [dbo].rTechObslug
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[AssetId] INT NOT NULL,
	[PartNumber] NVARCHAR(100) NOT NULL,
	[PrintedPages] INT NOT NULL, 
	[Date] DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,

	-- надо сделать св€зь с tblAssetCustom
	Constraint FK_tblAssetCustom_AssetID FOREIGN KEY (AssetId)
		References tblAssetCustom (AssetId),
	-- надо сделать св€зь с rRashoMaterial по полю јртикул
	Constraint FK_rRashodMaterial_PartNumber FOREIGN KEY (PartNumber)
		References rRashodMaterial (PartNumber)
);


-- —оздаем таблицу учитывающую расход материалов на устройствах
CREATE TABLE [dbo].rZayavkaOborud
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Type] nvarchar(100) NOT NULL,
	[idrPersonal] int NULL,
	[idrShtatR] INT NOT NULL, 
	[Comments] nvarchar(255) NULL,
	[Document] nvarchar(400) NOT NULL

	-- надо сделать св€зь с rShtatR
	Constraint FK_rShtatR_ID FOREIGN KEY (idrShtatR)
		References rShtatR (id),
);



