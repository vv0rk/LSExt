
use lansweeperdb;

go

/*
	через эту таблицу производится связь между asset в таблице rAsset и rSclad 
*/

if OBJECT_ID (N'rAssetsScladLink') is null
begin;
	create table dbo.rAssetsScladLink (
		Id int not null identity(1,1) primary key,
		AssetId int not null,
		Constraint FK_rAssetScladLink_rAssets_AssetId foreign key (AssetId)
			references dbo.tblAssets(AssetId),
		IdSclad int null,
		Constraint FK_rAssetScladLink_rSclad_IdSclad foreign key (IdSclad)
			references dbo.rSclad(Id)
	)
end;