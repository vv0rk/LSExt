use lansweeperdb;

go 

-- 00_���������� ������ (���������)
Select Top 1000000 a.AssetID As Id,
  a.AssetID,
  a.AssetName,
  ac.Model As '������ ����������',

  ac.Custom1 As '�����������',
  ac.Custom2 As '�����',
  ac.Custom3 As '�����',
  ac.Custom4 As '����',
  j.Printed As '������ ��.',
  f.Printed As '������� ��.',
  m.Printed As '���� ��.',
  ap.Printed As '������ ��.',
  ma.Printed As '��� ��.',
  jun.Printed As '���� ��.',
  july.Printed As '���� ��.',
  aug.Printed As '������ ��.',
  s.Printed As '�������� ��.',
  o.Printed As '������� ��.',
  nov.Printed As '������ ��.',
  december.Printed As '������� ��.'
From tblAssets As a
  Inner Join tblAssetCustom As ac On a.AssetID = ac.AssetID
  Inner Join tsysAssetTypes As at On a.Assettype = at.AssetType

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20170101' And '20170131'
  Group By ph.AssetId, mo.PartNumber) As j On a.AssetID = j.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20170201' And '20170228'
  Group By ph.AssetId, mo.PartNumber) As f On a.AssetID = f.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20170301' And '20170331'
  Group By ph.AssetId, mo.PartNumber) As m On a.AssetID = m.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20170401' And '20170430'
  Group By ph.AssetId, mo.PartNumber) As ap On a.AssetID = ap.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20170501' And '20170531'
  Group By ph.AssetId, mo.PartNumber) As ma On a.AssetID = ma.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20170601' And '20170630'
  Group By ph.AssetId, mo.PartNumber) As jun On a.AssetID = jun.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20170701' And '20170731'
  Group By ph.AssetId, mo.PartNumber) As july On a.AssetID = july.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20170801' And '20170831'
  Group By ph.AssetId, mo.PartNumber) As aug On a.AssetID = aug.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20160901' And '20160930'
  Group By ph.AssetId, mo.PartNumber) As s On a.AssetID = s.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20161001' And '20161031'
  Group By ph.AssetId, mo.PartNumber) As o On a.AssetID = o.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20161101' And '20161130'
  Group By ph.AssetId, mo.PartNumber) As nov On a.AssetID = nov.AssetId

  Left Join (Select ph.AssetId,
	mo.PartNumber as 'PartNumber',
    Count(ph.AssetId) As Printed
  From rSetRMHist As ph
  inner join dbo.rMaterialLink as ml on ph.IdMaterialAnalog = ml.IdAnalog
  inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id
  Where ph.Date Between '20161201' And '20161231'
  Group By ph.AssetId, mo.PartNumber) As december On a.AssetID = december.AssetId
Where at.AssetTypename = 'Printer' 