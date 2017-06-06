use lansweeperdb;

go

-- Добавляем новые асеты 
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

go

-- добавить новые модели которые определены в Lansweeper
insert into dbo.rModelLink (ModelAsset)
select distinct ac.Model
	from dbo.tblAssetCustom as ac
	inner join dbo.tblAssets as a on ac.AssetID = a.AssetID
	inner join dbo.tsysAssetTypes as at on a.Assettype = at.AssetType
	left join dbo.rModelLink as ml on ac.Model = ml.ModelAsset
	where at.AssetTypename = 'Printer' and ml.ModelAsset is null


go

-- обновляем серийные номера из реальных ассетов в эту копию
with c as (
select 
	a.assetid as idtgt
	, ac.assetid as idsrc
	, a.SerialNumber as stgt
	, ac.SerialNumber as ssrc
from dbo.rAsset as a
inner join dbo.tblAssetCustom as ac on a.assetid = ac.assetid
where (a.SerialNumber is null) or (a.SerialNumber <> ac.Serialnumber)
) update c
set 
stgt = ssrc;

go

-- Обновить поля на дочерних устройствах
with c as (
select 
	  acparent.Custom1 as Custom01_src
	, acparent.Custom2 as Custom02_src
	, acparent.Custom3 as Custom03_src
	, acparent.Custom4 as Custom04_src
	, acparent.Custom5 as Custom05_src
	, acparent.Custom10 as Custom10_src
	, acparent.Custom11 as Custom11_src
	, acparent.Custom19 as Custom19_src

	, acchild.Custom1 as Custom01_tgt
	, acchild.Custom2 as Custom02_tgt
	, acchild.Custom3 as Custom03_tgt
	, acchild.Custom4 as Custom04_tgt
	, acchild.Custom5 as Custom05_tgt
	, acchild.Custom10 as Custom10_tgt
	, acchild.Custom11 as Custom11_tgt
	, acchild.Custom19 as Custom19_tgt
	
	
from tblAssetRelations as ar
inner join tsysAssetRelationTypes as art on ar.Type = art.RelationTypeID
inner join tblAssets as aparent on ar.ParentAssetID = aparent.AssetID
inner join tblAssets as achild on ar.ChildAssetID = achild.AssetID
inner join tblAssetCustom as acparent on ar.ParentAssetID = acparent.AssetID
inner join tblAssetCustom as acchild on ar.ChildAssetID = acchild.AssetID

where art.name like 'Inside' or art.Name like 'Used With' or art.Name like 'Connected To' or art.Name like 'Backed Up To'
) update c set 
Custom01_tgt = Custom01_src,
Custom02_tgt = Custom02_src,
Custom03_tgt = Custom03_src,
Custom04_tgt = Custom04_src,
Custom05_tgt = Custom05_src,
Custom10_tgt = Custom10_src,
Custom11_tgt = Custom11_src,
Custom19_tgt = Custom19_src;


go

-- добавить новых пользователей и штатное расписание из Naumenf
-- добавление новых записей в таблицы
insert into dbo.rOUMod (removed, title, case_id, IdrOU, idparent_id)
select 
	ro.removed,
	ro.title,
	ro.case_id,
	ro.id,
	ro.parent_id

from rOU as ro
left join rOUMod as rom on ro.id = rom.IdrOU
where rom.Id is null
insert into dbo.rEmployeeMod( removed, title, post, parent_id, IdrEmployee, idparent_id)
select 
	e.removed
	, e.title
	, e.post
	, rom.Id
	, e.id
	, e.parent_id
from rEmployee as e 
left join rOUMod as rom on e.parent_id = rom.IdrOU
left join rEmployeeMod as em on e.id = em.IdrEmployee

where em.Id is null

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


/*
Добавляем исторические значения по количеству отпечатков в rPrintHist
*/
insert into dbo.rPrintHist (AssetId, Company, City, Address, Officenr, placenr, datecheck, printedpages )
SELECT 
	ac.AssetID
	, ac.Custom1
	, ac.Custom2
	, ac.Custom3
	, ac.Custom4
	, ac.Custom5
	, GetDate()
	, ac.Printedpages

  FROM [tblAssetCustom] as ac
  inner join tblAssets as a on ac.AssetID = a.AssetID
  inner join tsysAssetTypes as at on a.Assettype = at.AssetType

  where ( at.AssetTypename like 'Print%' ) and ( ac.Printedpages is not null )

