use lansweeperdb;

go

-- ��������� ������ �� ������� � ���������� �������� ������
select 
	s.Gorod as Gorod
	, mo.PartNumber as PartNumber
	, mo.Name 
	, sum(ps.Nr) as Number
from dbo.rPrihod as p
inner join dbo.rPrihodSpec as ps on p.Id = ps.IdPrihod
inner join dbo.rSclad as s on p.IdSclad = s.Id
inner join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id
inner join dbo.rMaterialAnalog as ma on cs.IdAnalog = ma.Id
inner join dbo.rMaterialLink as ml on ma.Id = ml.IdAnalog
inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

group by s.Gorod, mo.PartNumber, mo.Name

-- ��������� ������ �� ������� � ���������� �������� �������� ������
select 
	s.Gorod
	, mo.PartNumber
	, sum (mr.Number)
from dbo.rMaterialRashod as mr
inner join dbo.rSclad as s on mr.IdSclad = s.Id
inner join dbo.rMaterialLink as ml on mr.IdMaterialAnalog = ml.IdAnalog
inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

Group by s.Gorod, mo.PartNumber

-- ��������� ������ �� ������� � ���������� �������� ��������
select 
	s.Gorod
	, mo.PartNumber
	, sum (ts.Number) as Number

from dbo.rTransfer as t
inner join dbo.rSclad as s on t.IdScladTarget = s.Id
inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
inner join dbo.rMaterialOriginal as mo on ts.IdOriginal = mo.Id
where tst.Status like N'�%'

Group by s.Gorod, mo.PartNumber

-- ��������� ������ �� ������� � ���������� �������� ��������
select 
	s.Gorod
	, mo.PartNumber
	, sum (ts.Number) as Number

from dbo.rTransfer as t
inner join dbo.rSclad as s on t.IdScladSource = s.Id
inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
inner join dbo.rMaterialOriginal as mo on ts.IdOriginal = mo.Id
where tst.Status like N'�%'

Group by s.Gorod, mo.PartNumber


-- ��������� ������ �� ������� � ���������� �������� ������, �������� ������, �������� ������ !!! ����������� �������� = �������, ��������� ������ 
select *
from (
	select
		s.Gorod 
		, s.PartNumber
		, isnull(sum(pr.Number),0) + isnull(sum(pt.Number),0) - isnull(sum(rt.Number),0) - isnull(sum(mr.Number),0) as Number

	from (
		select 
			s.Gorod as Gorod
			, mo.PartNumber as PartNumber
		from dbo.rSclad s cross join dbo.rMaterialOriginal mo
	) as s

	left join (
		select 
			s.Gorod as Gorod
			, mo.PartNumber as PartNumber
			, sum(ps.Nr) as Number
		from dbo.rPrihod as p
		inner join dbo.rPrihodSpec as ps on p.Id = ps.IdPrihod
		inner join dbo.rSclad as s on p.IdSclad = s.Id
		inner join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id
		inner join dbo.rMaterialAnalog as ma on cs.IdAnalog = ma.Id
		inner join dbo.rMaterialLink as ml on ma.Id = ml.IdAnalog
		inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

		group by s.Gorod, mo.PartNumber, mo.Name
	) as pr on s.Gorod = pr.Gorod and s.PartNumber = pr.PartNumber

	left join (
		select 
			s.Gorod as Gorod
			, mo.PartNumber as PartNumber
			, sum (ts.Number) as Number

		from dbo.rTransfer as t
		inner join dbo.rSclad as s on t.IdScladTarget = s.Id
		inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
		inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
		inner join dbo.rMaterialOriginal as mo on ts.IdOriginal = mo.Id
		where tst.Status like N'�%'

		Group by s.Gorod, mo.PartNumber
	) as pt on s.Gorod = pt.Gorod and s.PartNumber = pt.PartNumber

	left join (
		select 
			s.Gorod			as Gorod
			, mo.PartNumber	as PartNumber
			, sum (ts.Number) as Number

		from dbo.rTransfer as t
		inner join dbo.rSclad as s on t.IdScladSource = s.Id
		inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
		inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
		inner join dbo.rMaterialOriginal as mo on ts.IdOriginal = mo.Id
		where tst.Status like N'�%'

		Group by s.Gorod, mo.PartNumber
	) as rt on s.Gorod = rt.Gorod and s.PartNumber = rt.PartNumber

	left join (
		select 
			s.Gorod as Gorod
			, mo.PartNumber as PartNumber
			, sum (mr.Number) as Number
		from dbo.rMaterialRashod as mr
		inner join dbo.rSclad as s on mr.IdSclad = s.Id
		inner join dbo.rMaterialLink as ml on mr.IdMaterialAnalog = ml.IdAnalog
		inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

		Group by s.Gorod, mo.PartNumber
	) as mr on s.Gorod = mr.Gorod and s.PartNumber = mr.PartNumber

	group by s.Gorod, s.PartNumber
) as src

where src.Number <> 0 --and src.Gorod = N'�������'
order by src.Gorod, src.Number

-- ��������� ������ �� ������� � ���������� �������� ������, �������� ������, �������� ������ !!! ����������� ������� � ������ !!!, ��������� ������, 
select *
from (
	select
		s.Gorod 
		, s.PartNumber
		, isnull(sum(pr.Number),0) + isnull(sum(pt.Number),0) - isnull(sum(rt.Number),0) - isnull(sum(mr.Number),0) as Number

	-- ��������� ������������ ������ rSclad � rMaterialOriginal
	from (
		select 
			s.Gorod as Gorod
			, mo.PartNumber as PartNumber
		from dbo.rSclad s cross join dbo.rMaterialOriginal mo
	) as s

	-- ������ ���������� �� �������
	left join (
		select 
			s.Gorod as Gorod
			, mo.PartNumber as PartNumber
			, sum(ps.Nr) as Number
		from dbo.rPrihod as p
		inner join dbo.rPrihodSpec as ps on p.Id = ps.IdPrihod
		inner join dbo.rSclad as s on p.IdSclad = s.Id
		inner join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id
		inner join dbo.rMaterialAnalog as ma on cs.IdAnalog = ma.Id
		inner join dbo.rMaterialLink as ml on ma.Id = ml.IdAnalog
		inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

		group by s.Gorod, mo.PartNumber, mo.Name
	) as pr on s.Gorod = pr.Gorod and s.PartNumber = pr.PartNumber

	-- ������ ���������� �� ��������
	left join (
		select 
			s.Gorod as Gorod
			, mo.PartNumber as PartNumber
			, sum (ts.Number) as Number

		from dbo.rTransfer as t
		inner join dbo.rSclad as s on t.IdScladTarget = s.Id
		inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
		inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
		inner join dbo.rMaterialOriginal as mo on ts.IdOriginal = mo.Id
		-- where tst.Status like N'�%'

		Group by s.Gorod, mo.PartNumber
	) as pt on s.Gorod = pt.Gorod and s.PartNumber = pt.PartNumber

	-- ������ ���������� ��� ��������
	left join (
		select 
			s.Gorod			as Gorod
			, mo.PartNumber	as PartNumber
			, sum (ts.Number) as Number

		from dbo.rTransfer as t
		inner join dbo.rSclad as s on t.IdScladSource = s.Id
		inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
		inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
		inner join dbo.rMaterialOriginal as mo on ts.IdOriginal = mo.Id
		-- where tst.Status like N'�%'

		Group by s.Gorod, mo.PartNumber
	) as rt on s.Gorod = rt.Gorod and s.PartNumber = rt.PartNumber

	-- ������ ���������� ��� ������� ���������� �� ����������
	left join (
		select 
			s.Gorod as Gorod
			, mo.PartNumber as PartNumber
			, sum (mr.Number) as Number
		from dbo.rMaterialRashod as mr
		inner join dbo.rSclad as s on mr.IdSclad = s.Id
		inner join dbo.rMaterialLink as ml on mr.IdMaterialAnalog = ml.IdAnalog
		inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

		Group by s.Gorod, mo.PartNumber
	) as mr on s.Gorod = mr.Gorod and s.PartNumber = mr.PartNumber

	group by s.Gorod, s.PartNumber
) as src

where src.Number <> 0 
order by src.Gorod, src.Number

-- ������� �������� 
select 
	src.AssetId
	, src.IdMaterialAnalog
	, AVG( delta) as average
	, count (delta ) as Cnt
from (
	select 
		mr.AssetId				as	AssetId
		, mr.IdMaterialAnalog	as IdMaterialAnalog
		, mr.Date				as DateChange
		, mr.PrintedPages		as PrintedPages
		, mr.PrintedPages - lag(mr.PrintedPages) over (Partition by mr.AssetId, mr.IdMaterialAnalog order by mr.AssetId, mr.IdMaterialAnalog, mr.Date) as delta
	from dbo.rMaterialRashod as mr
	--order by mr.AssetId, mr.IdMaterialAnalog, mr.Date
) as src

group by src.AssetId, src.IdMaterialAnalog
