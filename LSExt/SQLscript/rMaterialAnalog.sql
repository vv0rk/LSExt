
use lansweeperdb;

go

-- Таблица с аналогами расходных материалов
-- расходные материалы из этой таблицы назначаются на устройства
-- аналоги расходных материалов связаны с оригинальными расходными материалами через таблицу
-- rLinkMaterials
if object_id (N'rMaterialAnalog') is null
begin;
	CREATE TABLE [dbo].rMaterialAnalog
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		[IdManufacturer] INT NULL,
		-- код расходного материала по классификации производителя
		[PartNumber] NVARCHAR(100) NOT NULL,	-- сделать что это поле должно содержать только уникальные значения
			Constraint AK_rMaterialAnalog_PartNumber UNIQUE(PartNumber),
		-- название расходного материала
		[Name] NVARCHAR(255) NOT NULL, 
		-- ресурс расходного материала (опционально, если определено производителем)
		[Resource] INT NULL,

		-- альтернативное имя с префиксом ShortNameManufacturer space PartNumber
		[AltName] nvarchar(290) NULL,

		-- надо сделать связь с таблицей rManufacturer по полю ShortName
		Constraint FK_rManufacturer_rMaterialAnalog_Id FOREIGN KEY (IdManufacturer)
			References rManufacturer (Id)
	);
end;

-- добавляем столбец AltName
if not exists (
			select * 
			from sys.columns 
			where name = N'AltName')
	begin;
		Alter table rMaterialAnalog add AltName nvarchar(290) Null;
	end;

-- процедура добавления новой записи
drop trigger dbo.Trigger_rMaterialAnalog_Insert
drop trigger dbo.Trigger_rMaterialAnalog_Update
go

Create trigger Trigger_rMaterialAnalog_Insert on dbo.rMaterialAnalog instead of insert
as
	begin;
		insert into dbo.rMaterialAnalog
		(
			IdManufacturer
			, PartNumber
			, Name
			, Resource
			, AltName
		)
		select 
			i.IdManufacturer
			, i.PartNumber
			, i.Name
			, i.Resource
			, CONCAT(m.ShortName, ' ', i.PartNumber)
		from inserted as i 
		inner join dbo.rManufacturer as m on i.IdManufacturer = m.Id
	end;

go 

Create trigger Trigger_rMaterialAnalog_Update on dbo.rMaterialAnalog after update
as
	begin;

		update ma set AltName = CONCAT(m.ShortName, ' ', i.PartNumber)
		from dbo.rMaterialAnalog as ma 
		inner join inserted as i on i.Id = ma.Id
		inner join dbo.rManufacturer as m on i.IdManufacturer = m.Id
	end;



-- преобразование уже существующих данных переформатирование AltName
-- этот скрипт запускается только при необходимости переформатировать 
-- существующие данные
/*
use lansweeperdb;

go

with c as (
select 
	ma.AltName as AltName_tgt
	, CONCAT( m.ShortName, ' ', ma.PartNumber) as AltName_src
from dbo.rMaterialAnalog as ma 
left join dbo.rManufacturer as m on ma.IdManufacturer = m.Id
)
update c set
AltName_tgt = AltName_src;	
*/
