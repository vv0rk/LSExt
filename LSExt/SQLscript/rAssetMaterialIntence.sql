
use lansweeperdb;

go



/*
	���������� ���������� !!!!
	� ������������ � �����
	�������� ������ � ������������� ������������� ��������� ���������� �� ��������
	���� �������� ������� �� ����� ���������� ������� ��������������� �� ���� ����������
*/

if object_id (N'rAssetMaterialIntence') is null
begin;
	Create table dbo.rAssetMaterialIntence (
		Id int not null primary key,
		AssetId int not null,	-- ��� ������������ Asset
		Constraint FK_rAsserMaterialIntence_rAsset_AssetId_AssetId foreign key (AssetId)
			references rAsset (AssetId) on delete cascade, 
		IdMaterialOriginal int not null,	-- ��� ������������ �������� ����������� �� ���� ������
		Constraint FK_rAssetMaterialIntence_rMaterialOriginal_IdMaterial_Id foreign key (IdMaterialOriginal)
			references rMaterialOriginal (Id) on delete cascade,
		Intence float(24) not null default 1,	-- ������������� ������� ��������� �� �������� ������� �� ���� ����������
		NumberSclad int null,					-- ����� ��������� � ������� �������
		NumberOrg int null						-- ����� ��������� � ������� �����������
	)
end;

/*
	������ ��� ������������� ������� � ���� �������
	� ����������� ���������� ���
*/




/*
	������ ��� ������������� ��������
	���������� ���� ���� �� ���
*/

--insert into dbo.rAsset (
--	ac.AssetID,
--	ta.AssetName,
--	ac.Model,
--	t.AssetTypeName,
--	ac.Custom1,
--	ac.Custom2,
--	ac.Custom3,
--	ac.Custom4,
--	ac.Custom5,
--	ac.Custom6,
--	ac.Custom7,
--	ac.Custom8,
--	ac.Custom9,
--	ac.Custom10,
--	ac.Custom11,
--	ac.Custom12,
--	ac.Custom13,
--	ac.Custom14,
--	ac.Custom15,
--	ac.Custom16,
--	ac.Custom17,
--	ac.Custom18,
--	ac.Custom19,
--	ac.Custom20
--)
--select 
--	ac.AssetID,
--	ta.AssetName,
--	ac.Model,
--	t.AssetTypeName,
--	ac.Custom1,
--	ac.Custom2,
--	ac.Custom3,
--	ac.Custom4,
--	ac.Custom5,
--	ac.Custom6,
--	ac.Custom7,
--	ac.Custom8,
--	ac.Custom9,
--	ac.Custom10,
--	ac.Custom11,
--	ac.Custom12,
--	ac.Custom13,
--	ac.Custom14,
--	ac.Custom15,
--	ac.Custom16,
--	ac.Custom17,
--	ac.Custom18,
--	ac.Custom19,
--	ac.Custom20
--from dbo.tblAssetCustom as ac 
--inner join dbo.tblAssets as ta on ac.AssetID = ta.AssetID
--inner join dbo.tsysAssetTypes as t on ta.Assettype = t.AssetType
--left join dbo.rAsset as a on ac.AssetID = a.AssetId
--where a.AssetId is null
