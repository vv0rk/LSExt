-- Создаем две таблицы Штатного расписания
-- Само штатное расписание и персонал
CREATE TABLE [dbo].rShtatR
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Company] NVARCHAR(255) NOT NULL, 
    [Filial] NVARCHAR(255) NULL, 
    [Departament] NVARCHAR(255) NULL, 
    [Upravlenie] NVARCHAR(255) NULL, 
    [Grupa] NVARCHAR(255) NULL, 
    [Otdel] NVARCHAR(255) NULL, 
    [Dolgnost] NVARCHAR(255) NOT NULL,
	
	[idrPersonal] INT NULL,				-- это поле заполняется при назначении сотрудника на должность
	[idOld] int null					-- временно поле дял установления связи
)

-- Персонал
CREATE TABLE [dbo].rPersonalNew
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    [Familia] NVARCHAR(255) NULL, 
    [Imya] NVARCHAR(255) NULL, 
    [Otchestvo] NVARCHAR(255) NULL, 
    [FIO] NVARCHAR(255) NULL, 
    [Tabel] NVARCHAR(50) NULL, 
    [DatePriem] DateTime NULL,			-- планируемая дата приема сотрудника на должность
    [DateUvol] DateTime NULL,			-- планируемая дата увольнения сотрудника с должности
	[Status] NVARCHAR(50) NULL,

    [idrShtatR] int NULL,				-- это поле заполняется при назначении сотрудника на должность 
	[idOld] int null					-- временно поле дял установления связи
)
