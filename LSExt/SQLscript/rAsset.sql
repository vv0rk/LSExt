
use lansweeperdb;

go

/*
	записи в эту таблицу должны добавляться раз в сутки
	для этого надо скрипт разработать и запустить по расписанию
*/

if object_id (N'rAsset') is null
begin;
	Create table dbo.rAsset (
		AssetId int not null primary key,
		AssetName nvarchar(200) not null,
		Model nvarchar(200) null,
		AssetTypeName nvarchar(100) not null,
		Custom1 nvarchar(255) null,
		Custom2 nvarchar(255) null,
		Custom3 nvarchar(255) null,
		Custom4 nvarchar(255) null,
		Custom5 nvarchar(255) null,
		Custom6 nvarchar(255) null,
		Custom7 nvarchar(255) null,
		Custom8 nvarchar(255) null,
		Custom9 nvarchar(255) null,
		Custom10 nvarchar(255) null,
		Custom11 nvarchar(255) null,
		Custom12 nvarchar(255) null,
		Custom13 nvarchar(255) null,
		Custom14 nvarchar(255) null,
		Custom15 nvarchar(255) null,
		Custom16 nvarchar(255) null,
		Custom17 nvarchar(255) null,
		Custom18 nvarchar(255) null,
		Custom19 nvarchar(255) null,
		Custom20 nvarchar(255) null
	)
end;

/*
	Скрипт для синхронизации объектов
	добавления если чего то нет
*/

insert into dbo.rAsset (
	ac.AssetID,
	ta.AssetName,
	ac.Model,
	t.AssetTypeName,
	ac.Custom1,
	ac.Custom2,
	ac.Custom3,
	ac.Custom4,
	ac.Custom5,
	ac.Custom6,
	ac.Custom7,
	ac.Custom8,
	ac.Custom9,
	ac.Custom10,
	ac.Custom11,
	ac.Custom12,
	ac.Custom13,
	ac.Custom14,
	ac.Custom15,
	ac.Custom16,
	ac.Custom17,
	ac.Custom18,
	ac.Custom19,
	ac.Custom20
)
select 
	ac.AssetID,
	ta.AssetName,
	ac.Model,
	t.AssetTypeName,
	ac.Custom1,
	ac.Custom2,
	ac.Custom3,
	ac.Custom4,
	ac.Custom5,
	ac.Custom6,
	ac.Custom7,
	ac.Custom8,
	ac.Custom9,
	ac.Custom10,
	ac.Custom11,
	ac.Custom12,
	ac.Custom13,
	ac.Custom14,
	ac.Custom15,
	ac.Custom16,
	ac.Custom17,
	ac.Custom18,
	ac.Custom19,
	ac.Custom20
from dbo.tblAssetCustom as ac 
inner join dbo.tblAssets as ta on ac.AssetID = ta.AssetID
inner join dbo.tsysAssetTypes as t on ta.Assettype = t.AssetType
left join dbo.rAsset as a on ac.AssetID = a.AssetId
where a.AssetId is null
