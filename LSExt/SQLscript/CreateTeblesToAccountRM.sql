use lansweeperdb;

go 

-- Создаем таблицу с устройствами для формирования заявок
CREATE TABLE [dbo].rDvicesList
(
	[DeviceName] NVARCHAR(100) NOT NULL PRIMARY KEY,
	[Comment] NVARchar(255) NULL	-- Обязательно указание штатной единицы для которой указывается заявка на оборудование
);



-- Создаем таблицу с заявками полученными от пользователей
CREATE TABLE [dbo].rZayavka
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[DeviceList] NVARCHAR(100) NOT NULL,
	[idrShtatR] INT NOT NULL,	-- Обязательно указание штатной единицы для которой указывается заявка на оборудование
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

	-- Связка Заявки со спецификацией
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

	-- Связка Заявки со спецификацией
	Constraint FK_rZakupka_rSpec Foreign Key (idrSpec)
	References rSpec (Id),
);


-- определяем города 
CREATE TABLE [dbo].rGorod
(
	[Id] INT NOT NULL Identity(1,1) PRImary key,
	[Gorod] NVARCHAR(100) NOT NULL,

	-- Связка Заявки со спецификацией
	Constraint AK_rGorod_Gorod Unique(Gorod)
);

