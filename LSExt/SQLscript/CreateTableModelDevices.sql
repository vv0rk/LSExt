use lansweeperdb;

go

drop table [dbo].rModelComplect
drop table [dbo].rModelDevice

-- Таблица со статусами расходных материалов в комплектах 
-- выбрать среди всех материалов те, которые будут использоваться при заявках
-- например 2 картриджа обычный и большой емкости, тот который хотим заказать ставим статус ДА
Create table rModelComplectStatus
(
	[Id]	Int not null identity(1,1) primary key,
	[Status]	nvarchar(3) not null 
)

-- Таблица с моделями устройств (модели всех устройств должны быть приведены в соответствие с этой таблицей)
CREATE TABLE [dbo].rModelDevice
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Model] NVARCHAR(255) NOT NULL,
		Constraint AK_Model UNIQUE(Model),
	[IdManufacturer] INT,
		Constraint FK_rManufacturer_rModelDevice_IdManufacturer FOREIGN KEY (IdManufacturer)
			References rManufacturer (Id)
);

-- Комплекты материалов на устройствах
-- Материалы которые могут быть применены к устройствам.
-- эта таблица используется при назначении аналога на устройство (аналог может быть назначен только в том случае если он является аналогом 
-- оригинального расходного материала который входит в комплект для этого устройства)
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



