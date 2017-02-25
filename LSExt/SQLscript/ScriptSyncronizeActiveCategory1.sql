
use lansweeperdb;

go

/*
	Этот скрипт автоматически связывает объекты из rActiveCategory1 с объектами из tblAssetCustom
	связывается на базе серийного номера или инвентарного номера
*/

with c as (
select 
	a.AssetId as AssetIdTgt
	, ac.AssetID as AssetIdSrc
from dbo.rActiveCategory1 as a
inner join dbo.tblAssetCustom as ac on a.nrSerial = ac.Serialnumber
)
update c set
	AssetIdTgt = AssetIdSrc;

go

with c as (
select 
	a.AssetId as AssetIdTgt
	, ac.AssetID as AssetIdSrc
from dbo.rActiveCategory1 as a
inner join dbo.tblAssetCustom as ac on a.nrInv = ac.Custom7
)
update c set
	AssetIdTgt = AssetIdSrc;



