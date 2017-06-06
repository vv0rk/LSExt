use lansweeperdb;

go

/*
	�������������� ��������� �� ����������� ���������� � �������
	�������� ��� ���������, ������� ������� ������ �����:
		'Inside' 
		'Used With' 
		'Connected To' 
		'Backed Up To'
	���������������� ��������� ���������:
		�����������					- Custom01
		�����						- Custom02
		�����						- Custom03
		� �������					- Custom04
		� �����						- Custom05
		��������� ������������		- Custom10
		��� ������������			- Custom11
		��� ������������� ������	- Custom19
*/

select 
	
from tblAssetRelations as ar
inner join tsysAssetRelationTypes as art on ar.Type = art.RelationTypeID
inner join tblAssets as aparent on ar.ParentAssetID = aparent.AssetID
inner join tblAssets as achild on ar.ChildAssetID = achild.AssetID
inner join tblAssetCustom as acparent on ar.ParentAssetID = acparent.AssetID
inner join tblAssetCustom as acchild on ar.ChildAssetID = acchild.AssetID

where art.name like 'Inside' or art.Name like 'Used With' or art.Name like 'Connected To' or art.Name like 'Backed Up To'