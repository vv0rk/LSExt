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
	,a.AssetName as '��� ����������'
	,ac.Serialnumber
	,ac.Model
	,ac.Custom1 as '�����������'
	,ac.Custom2 as '�����'
	,ac.Custom3 as '�����'
	,ac.Custom4 as '����'
	,ac.Custom6 as '�������� �������'
	,ac.Custom7 as '����������� �����'
	,ac.Custom11 as '��� ������������'
	,ac.Custom19 as '��� ������������� ������'
	,at.AssetTypename

from dbo.tblAssetCustom as ac
inner join dbo.tblAssets as a on ac.AssetID = a.AssetID
inner join dbo.tsysAssetTypes as at on a.Assettype = at.AssetType