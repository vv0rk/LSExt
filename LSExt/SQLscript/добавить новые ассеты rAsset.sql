use lansweeperdb;

go


insert into dbo.rAsset (
[AssetId]
      ,[AssetName]
      ,[Model]
      ,[AssetTypeName]
      ,[Custom1]
      ,[Custom2]
      ,[Custom3]
      ,[Custom4]
      ,[Custom5]
      ,[Custom6]
      ,[Custom7]
      ,[Custom8]
      ,[Custom9]
      ,[Custom10]
      ,[Custom11]
      ,[Custom12]
      ,[Custom13]
      ,[Custom14]
      ,[Custom15]
      ,[Custom16]
      ,[Custom17]
      ,[Custom18]
      ,[Custom19]
      ,[Custom20]

)

select 
ac.[AssetId]
      ,a.[AssetName]
      ,ac.[Model]
      ,at.[AssetTypeName]
      ,ac.[Custom1]
      ,ac.[Custom2]
      ,ac.[Custom3]
      ,ac.[Custom4]
      ,ac.[Custom5]
      ,ac.[Custom6]
      ,ac.[Custom7]
      ,ac.[Custom8]
      ,ac.[Custom9]
      ,ac.[Custom10]
      ,ac.[Custom11]
      ,ac.[Custom12]
      ,ac.[Custom13]
      ,ac.[Custom14]
      ,ac.[Custom15]
      ,ac.[Custom16]
      ,ac.[Custom17]
      ,ac.[Custom18]
      ,ac.[Custom19]
      ,ac.[Custom20]
	  
from dbo.tblAssetCustom as ac
inner join dbo.tblAssets as a on ac.AssetID = a.AssetID
inner join dbo.tsysAssetTypes as at on a.Assettype = at.AssetType
where not exists (
	select a.AssetId
	from dbo.rAsset as a
	where a.AssetId = ac.AssetID
)

