use lansweeperdb;

go 

Create view rwebAssets(
	AssetId
	, AssetName 
	, SerialNumber
	, Model
	, Custom1
	, Custom2
	, Custom3
	, Custom4
	, Custom6
	, Custom7
	, Custom11
	, Custom19
	, AssettypeName
	)
as select 
	ac.AssetID
	,a.AssetName as 'Имя устройства'
	,ac.Serialnumber
	,ac.Model
	,ac.Custom1 as 'Организация'
	,ac.Custom2 as 'Город'
	,ac.Custom3 as 'Адрес'
	,ac.Custom4 as 'Офис'
	,ac.Custom6 as 'Владелец техники'
	,ac.Custom7 as 'Инвентарный номер'
	,ac.Custom11 as 'ФИО пользователя'
	,ac.Custom19 as 'ФИО ответственный ВТшник'
	,at.AssetTypename

from dbo.tblAssetCustom as ac
inner join dbo.tblAssets as a on ac.AssetID = a.AssetID
inner join dbo.tsysAssetTypes as at on a.Assettype = at.AssetType