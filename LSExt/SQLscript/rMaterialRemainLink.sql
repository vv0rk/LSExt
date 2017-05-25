
use lansweeperdb;

go

/*
»нформаци€ об остатках ресурсных запчастей на устройствах
*/

if OBJECT_ID (N'rMaterialRemainLink') is null
	begin;
		Create table rMaterialRemainLink
		(
			[Id] int not null identity(1,1) primary key,
			[idModel] int not null,		-- идентификатор моделей беретс€ из справочника моделей
			Constraint FK_rMaterialRemainLink_rModelDevice_idModel_Id foreign key (idModel)
				references rModelDevice(Id) on delete cascade,
			[TonerName] nvarchar(150) not null,
			[TonerColorName] nvarchar(100) null,
			[idMaterialOriginal] int null,
			Constraint FK_rMaterialRemainLink_rMaterialOriginal_idMaterialOriginal_Id foreign key (idMaterialOriginal)
				references rMaterialOriginal(Id) on delete cascade,
		)
	end;

drop index IX_rMaterialRemainLink_idModel_TonerName_TonerColorName on dbo.rMaterialRemainLink;
Create UNIQUE index IX_rMaterialRemainLink_idModel_TonerName_TonerColorName on dbo.rMaterialRemainLink (idModel, TonerName, TonerColorName);

-- процедура заполн€юща€ эту таблицу значени€ми idModel + TonerName
insert into dbo.rMaterialRemainLink (idModel, TonerName, TonerColorName)
select distinct 
	md.Id
	--, md.Model
	, cdp.Tonername
	, cdp.TonerColorName
from dbo.tblCustDevPrinter as cdp
inner join dbo.tblAssetCustom as ac on cdp.AssetID = ac.AssetID
inner join dbo.rModelLink as ml on ac.Model = ml.ModelAsset
inner join dbo.rModelDevice as md on ml.ModelSprav = md.Model
left join dbo.rMaterialRemainLink as mrl on md.Id = mrl.idModel and cdp.Tonername = mrl.TonerName and cdp.TonerColorName = mrl.TonerColorName
where mrl.Id is null 


/*
скрипт дл€ проверки 
select ac.AssetID
	, ml.ModelSprav
	, cdp.*
from dbo.tblCustDevPrinter as cdp
inner join dbo.tblAssetCustom as ac on cdp.AssetId = ac.AssetID
inner join dbo.rModelLink as ml on ac.Model = ml.ModelAsset

where ml.ModelSprav like N'%3040%'
*/
