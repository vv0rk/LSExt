
use lansweeperdb;

go

/*
	записи в эту таблицу должны добавляться раз в сутки
	для этого надо скрипт разработать и запустить по расписанию
*/

if object_id (N'rPrintHist') is null
begin;
	Create table dbo.rPrintHist (
		Id int not null identity(1,1) primary key,
		AssetId int not Null,
		Company nvarchar(255) null,
		City nvarchar(255) null,
		Address nvarchar(255) null,
		Officenr nvarchar(255) null,
		Placenr nvarchar(255) null,
		datecheck datetime null,
		printedpages numeric(18,0) null,
		IdMaterialRashod int null,
		Constraint FK_rPrintHist_rRashodMaterial_IdMaterialRashod foreign key (IdMaterialRashod)
			references rMaterialRashod(Id),
		IdAssetTransfer int null,
		Constraint FK_rPrintHist_rAssetTransfer_IdAssetTransfer foreign key (IdAssetTransfer)
			references rAssetTransfer (Id) on Delete Cascade
	)
end;

Alter table rPrintHist add IdAssetTransfer int null;
Alter table rPrintHist add Constraint FK_rPrintHist_rAssetTransfer_IdAssetTransfer foreign key (IdAssetTransfer)
			references rAssetTransfer (Id) on Delete Cascade;
