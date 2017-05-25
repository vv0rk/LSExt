use lansweeperdb;

go

/*
	автоматическое добавление записей программ из tblSoftwareUni
	в rCatalogProg
*/
insert into dbo.rCatalogProg ( softwareName )
select pp.sName
from  (
	select distinct 
		su.softwareName as sName
	From tblSoftware
	  Inner Join tblAssets On tblSoftware.AssetID = tblAssets.AssetID
	  Inner Join tblSoftwareUni as su On tblSoftware.softID = su.SoftID
	  Inner Join tblAssetCustom On tblAssets.AssetID = tblAssetCustom.AssetID
	  Inner Join tblState On tblAssetCustom.State = tblState.State
	  Left Join tblOperatingsystem As OS On OS.AssetID = tblAssets.AssetID
	  Left Join rCompany$ As c On tblAssetCustom.Custom1 = c.Code
	Where tblState.Statename Like '%Active%' and os.Caption not Like '%Server%'
) as  pp
left join rCatalogProg as cp on pp.sName = cp.softwareName

where cp.softwareName is null