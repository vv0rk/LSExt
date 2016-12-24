use lansweeperdb;

go

-- Создаем таблицу с производителями устройств, расходных материалов и комплектующих
CREATE TABLE [dbo].rManufacturer
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[FullName] NVARCHAR(255),
	[ShortName] NVARCHAR(100) NOT NULL,	-- сделать что это поле должно содержать только уникальные значения
	Constraint AK_ShortName UNIQUE(ShortName)
);