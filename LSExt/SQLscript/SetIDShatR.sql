use lansweeperdb;

go

use lansweeperdb;

go

with c as (
select
	ac.AssetID,
	ac.Custom1,
	ac.Custom10,
	ac.Custom11,
	ac.Custom18 as tgt_idShtat,
	sr.Id as src_idShtat,
	sr.Dolgnost,
	p.FIO 

from tblAssetCustom as ac
inner join rPersonalNew as p on p.FIO = ac.Custom11
inner join rShtatR as sr on p.idrShtatR = sr.id

where p.FIO not like N'%вакансия%' and p.FIO is not null
)
update c set
	tgt_idShtat = src_idShtat;