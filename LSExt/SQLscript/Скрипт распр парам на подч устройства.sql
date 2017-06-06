use lansweeperdb;

go

/*
	Распространяет параметры на подчиненные устройства с главных
	работает для устройств, которые связаны типами связи:
		'Inside' 
		'Used With' 
		'Connected To' 
		'Backed Up To'
	Распространяются следующие параметры:
		Организация					- Custom01
		Город						- Custom02
		Адрес						- Custom03
		№ кабинет					- Custom04
		№ места						- Custom05
		Должность пользователя		- Custom10
		ФИО пользователя			- Custom11
		ФИО ответственный ВТшник	- Custom19
*/

select 
	
from tblAssetRelations as ar
inner join tsysAssetRelationTypes as art on ar.Type = art.RelationTypeID
inner join tblAssets as aparent on ar.ParentAssetID = aparent.AssetID
inner join tblAssets as achild on ar.ChildAssetID = achild.AssetID
inner join tblAssetCustom as acparent on ar.ParentAssetID = acparent.AssetID
inner join tblAssetCustom as acchild on ar.ChildAssetID = acchild.AssetID

where art.name like 'Inside' or art.Name like 'Used With' or art.Name like 'Connected To' or art.Name like 'Backed Up To'