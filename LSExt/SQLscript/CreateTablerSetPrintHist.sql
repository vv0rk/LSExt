use lansweeperdb;

go

-- Создаем таблицу с производителями устройств, расходных материалов и комплектующих
CREATE TABLE [dbo].rSetPrintHist
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[AssetId] INT Not null,
	Company		nvarchar(255) null,
	City		nvarchar(255) null,
	[Address]	nvarchar(255) null,
	[Officenr]	nvarchar(255) null,
	[Placenr]	nvarchar(255) null,
	datecheck	datetime null,
	printedpages	numeric(18,0)	null
);