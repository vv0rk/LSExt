
use lansweeperdb;

go

/*
	���� ������ ������������� ��������� ������� �� rActiveCategory1 � ��������� �� tblAssetCustom
	����������� �� ���� ��������� ������ ��� ������������ ������
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



