use lansweeperdb;

go


-- !!!!! �������� � �������� !!!!!!
-- !!!!! ����������� � ������ � ��������� !!!!!

/*
	���������� ��������� ������ ���������� ������� ��� ��� 
	������������� ������ � �������
*/
insert into dbo.rScladMaterialAnalog(
	IdSclad
	, IdMaterialAnalog
)
select 
	s.Id
	, mo.Id
from dbo.rSclad as s
cross join dbo.rMaterialAnalog as mo
left join dbo.rScladMaterialAnalog as smo on s.Id = smo.IdSclad and mo.Id = smo.IdMaterialAnalog
where smo.Id is null

go

insert into dbo.rSclad1CSprav(
	IdSclad
	, Id1CSprav
)
select 
	s.Id
	, cs.Id
from dbo.rSclad as s
cross join dbo.r1CSprav as cs
left join dbo.rSclad1CSprav as ss on s.Id = ss.IdSclad and cs.Id = ss.Id1CSprav
where ss.Id is null

go

insert into dbo.rScladMaterialOriginal(
	IdSclad
	, IdMaterialOriginal
)
select 
	s.Id
	, mo.Id
from dbo.rSclad as s
cross join dbo.rMaterialOriginal as mo
left join dbo.rScladMaterialOriginal as smo on s.Id = smo.IdSclad and mo.Id = smo.IdMaterialOriginal
where smo.Id is null


/*
	���������� �������� rScladMaterialAnalog
*/
go 
with C as (
	select
		smon.Number as Number_src
		, smo.Number as Number_tgt
	from dbo.rScladMaterialAnalog as smo
	left join (
		select 
			src.IdSclad
			, src.IdMaterialAnalog
			, src.Number
		from (
			select
				s.IdSclad
				, s.IdMaterialAnalog
				, isnull(sum(pr.Number),0) + isnull(sum(pt.Number),0) - isnull(sum(rt.Number),0) - isnull(sum(mr.Number),0) as Number

			from dbo.rScladMaterialAnalog as s

			/* ��������� ��� �������!!!
			   ����������� ��� ���� 1� ������� ������� �� ����� ����������� ������ ����������� �������:
			   1. ������������ � ������� ������ ������������� � rMaterialAnalog
			   2. ������������ � ����������� ������ ����� ������������ � rMaterialAnalog
					� ������� r1CSprav ������� ���� ����� IdAnalog int
			   3. ������ �� rMaterialAnalog ������ ���� ������� � rMaterialAnalog (����� rMaterialLink)
			*/ 
			left join (
				select 
					s.Id as IdSclad
					, mo.Id as IdMaterialAnalog
					, sum(ps.Nr) as Number
				from dbo.rPrihod as p
				inner join dbo.rPrihodSpec as ps on p.Id = ps.IdPrihod
				inner join dbo.rSclad as s on p.IdSclad = s.Id
				inner join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id
				inner join dbo.rMaterialAnalog as ma on cs.IdAnalog = ma.Id
				inner join dbo.rMaterialLink as ml on ma.Id = ml.IdAnalog
				inner join dbo.rMaterialAnalog as mo on ml.IdOriginal = mo.Id

				group by s.Id, mo.Id
			) as pr on s.IdSclad = pr.IdSclad and s.IdMaterialAnalog = pr.IdMaterialAnalog

			/*
				��������� ����������� �� ������ ���������� �� �������� ����������� ���������
			*/
			left join (
				select 
					s.Id as IdSclad
					, mo.Id as IdMaterialAnalog
					, sum (ts.Number) as Number

				from dbo.rTransfer as t
				inner join dbo.rSclad as s on t.IdScladTarget = s.Id
				inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
				inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
				inner join dbo.rMaterialAnalog as mo on ts.IdOriginal = mo.Id
				where tst.Status like N'�%'

				Group by s.Id, mo.Id
			) as pt on s.IdSclad = pt.IdSclad and s.IdMaterialAnalog = pt.IdMaterialAnalog

			left join (
				select 
					s.Id		as IdSclad
					, mo.Id	as IdMaterialAnalog
					, sum (ts.Number) as Number

				from dbo.rTransfer as t
				inner join dbo.rSclad as s on t.IdScladSource = s.Id
				inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
				inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
				inner join dbo.rMaterialAnalog as mo on ts.IdOriginal = mo.Id
				where tst.Status like N'�%'

				Group by s.Id, mo.Id
			) as rt on s.IdSclad = rt.IdSclad and s.IdMaterialAnalog = rt.IdMaterialAnalog

			left join (
				select 
					s.Id as IdSclad
					, mo.Id as IdMaterialAnalog
					, sum (mr.Number) as Number
				from dbo.rMaterialRashod as mr
				inner join dbo.rSclad as s on mr.IdSclad = s.Id
				inner join dbo.rMaterialLink as ml on mr.IdMaterialAnalog = ml.IdAnalog
				inner join dbo.rMaterialAnalog as mo on ml.IdOriginal = mo.Id

				Group by s.Id, mo.Id
			) as mr on s.IdSclad = mr.IdSclad and s.IdMaterialAnalog = mr.IdMaterialAnalog

			group by s.IdSclad, s.IdMaterialAnalog
		) as src
		inner join dbo.rSclad as s on src.IdSclad = s.Id

		where src.Number <> 0 --and src.Gorod = N'�������'
		--order by src.IdSclad, src.Number
	) as smon on smo.IdSclad = smon.IdSclad and smo.IdMaterialAnalog = smon.IdMaterialAnalog
) 
Update C set
Number_tgt = Number_src;


/*
	���������� �������� rSclad1CSprav
*/
go
with c as (
	select
		smo.Number as Number_tgt
		,smon.Number as Number_src
	from dbo.rSclad1CSprav as smo

	left join (
	select 
		src.IdSclad
		, src.Id1CSprav
		, src.Number
	from (
		select
			s.IdSclad
			, s.Id1CSprav
			-- pr + pt - rt - mr
			, isnull(sum(pr.Number),0) + isnull(sum(pt.Number),0) - isnull(sum(rt.Number),0) - isnull(sum(mr.Number),0) as Number

		from dbo.rSclad1CSprav as s

		/* ��������� ��� �������!!!
		   ����������� ��� ���� 1� ������� ������� �� ����� ����������� ������ ����������� �������:
		   1. ������������ � ������� ������ ������������� � r1CSprav
		   2. ������������ � ����������� ������ ����� ������������ � rMaterialAnalog
				� ������� r1CSprav ������� ���� ����� IdAnalog int
		   3. ������ �� rMaterialAnalog ������ ���� ������� � r1CSprav (����� rMaterialLink)
		*/ 
		left join (
			select 
				s.Id as IdSclad
				, cs.nrNom
				, cs.Id as Id1CSprav
				, sum(ps.Nr) as Number
			from dbo.rPrihod as p
			inner join dbo.rPrihodSpec as ps on p.Id = ps.IdPrihod
			inner join dbo.rSclad as s on p.IdSclad = s.Id
			inner join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id

			group by s.Id, cs.Id, cs.nrNom
		) as pr on s.IdSclad = pr.IdSclad and s.Id1CSprav = pr.Id1CSprav

		/*
			��������� ����������� �� ������ ���������� �� �������� ����������� ���������
			�� ������� ������
		*/
		left join (
			select 
				s.Id as IdSclad
				, cs.Id as Id1CSprav
				, cs.nrNom as PartNumber
				, sum (ts.Number) as Number

			from dbo.rTransfer as t
			inner join dbo.rSclad as s on t.IdScladTarget = s.Id
			inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
			inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
			inner join dbo.r1CSprav as cs on ts.Id1CSprav = cs.Id

			where tst.Status like N'�%'

			Group by s.Id, cs.Id, cs.nrNom 
		) as pt on s.IdSclad = pt.IdSclad and s.Id1CSprav = pt.Id1CSprav

		/*
			��������� ����������� �� ������ ��������� �� �������� ����������� ���������
			�� ������� ������
			����� �������������� ��� ������ �� ������ �� ������
		*/
		left join (
			select 
				s.Id as IdSclad
				, cs.Id as Id1CSprav
				, cs.nrNom as PartNumber
				, sum (ts.Number) as Number

			from dbo.rTransfer as t
			inner join dbo.rSclad as s on t.IdScladSource = s.Id
			inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
			inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
			inner join dbo.r1CSprav as cs on ts.Id1CSprav = cs.Id

			where tst.Status like N'�%'

			Group by s.Id, cs.Id, cs.nrNom 
		) as rt on s.IdSclad = rt.IdSclad and s.Id1CSprav = rt.Id1CSprav

		/* 
			��������� ��� �������� ������� �� ������
			���������� �� ������ ���������
		*/
		left join (
			select 
				s.Id as IdSclad
				, mo.Id as Id1CSprav
				, mo.nrNom as PartNumber
				, sum (mr.Number) as Number
			from dbo.rMaterialRashod as mr
			inner join dbo.rSclad as s on mr.IdSclad = s.Id
			inner join dbo.r1CSprav as mo on mr.Id1CSprav = mo.Id

			Group by s.Id, mo.Id, mo.nrNom
		) as mr on s.IdSclad = mr.IdSclad and s.Id1CSprav = mr.Id1CSprav

		group by s.IdSclad, s.Id1CSprav

	) as src

	inner join dbo.rSclad as s on src.IdSclad = s.Id

	where src.Number <> 0 --and src.Gorod = N'�������'
	--order by src.IdSclad, src.Number
	) as smon on smo.IdSclad = smon.IdSclad and smo.Id1CSprav = smon.Id1CSprav

)
update c set 
Number_tgt = Number_src;

/*
	���������� �������� rScladMaterialOriginal
*/
go
with C as (
	select
		smon.Number as Number_src
		, smo.Number as Number_tgt
		from dbo.rScladMaterialOriginal as smo
	left join (
	select 
		src.IdSclad
		, src.IdMaterialOriginal
		, src.Number
	from (
		select
			s.IdSclad
			, s.IdMaterialOriginal
			, isnull(sum(pr.Number),0) + isnull(sum(pt.Number),0) - isnull(sum(rt.Number),0) - isnull(sum(mr.Number),0) as Number

		from dbo.rScladMaterialOriginal as s

		/* ��������� ��� �������!!!
		   ����������� ��� ���� 1� ������� ������� �� ����� ����������� ������ ����������� �������:
		   1. ������������ � ������� ������ ������������� � r1CSprav
		   2. ������������ � ����������� ������ ����� ������������ � rMaterialAnalog
				� ������� r1CSprav ������� ���� ����� IdAnalog int
		   3. ������ �� rMaterialAnalog ������ ���� ������� � rMaterialOriginal (����� rMaterialLink)
		*/ 
		left join (
			select 
				s.Id as IdSclad
				, mo.Id as IdMaterialOriginal
				, sum(ps.Nr) as Number
			from dbo.rPrihod as p
			inner join dbo.rPrihodSpec as ps on p.Id = ps.IdPrihod
			inner join dbo.rSclad as s on p.IdSclad = s.Id
			inner join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id
			inner join dbo.rMaterialAnalog as ma on cs.IdAnalog = ma.Id
			inner join dbo.rMaterialLink as ml on ma.Id = ml.IdAnalog
			inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

			group by s.Id, mo.Id
		) as pr on s.IdSclad = pr.IdSclad and s.IdMaterialOriginal = pr.IdMaterialOriginal

		/*
			��������� ����������� �� ������ ���������� �� �������� ����������� ���������
		*/
		left join (
			select 
				s.Id as IdSclad
				, mo.Id as IdMaterialOriginal
				, sum (ts.Number) as Number

			from dbo.rTransfer as t
			inner join dbo.rSclad as s on t.IdScladTarget = s.Id
			inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
			inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
			inner join dbo.rMaterialOriginal as mo on ts.IdOriginal = mo.Id
			where tst.Status like N'�%'

			Group by s.Id, mo.Id
		) as pt on s.IdSclad = pt.IdSclad and s.IdMaterialOriginal = pt.IdMaterialOriginal

		left join (
			select 
				s.Id		as IdSclad
				, mo.Id	as IdMaterialOriginal
				, sum (ts.Number) as Number

			from dbo.rTransfer as t
			inner join dbo.rSclad as s on t.IdScladSource = s.Id
			inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
			inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
			inner join dbo.rMaterialOriginal as mo on ts.IdOriginal = mo.Id
			where tst.Status like N'�%'

			Group by s.Id, mo.Id
		) as rt on s.IdSclad = rt.IdSclad and s.IdMaterialOriginal = rt.IdMaterialOriginal

		left join (
			select 
				s.Id as IdSclad
				, mo.Id as IdMaterialOriginal
				, sum (mr.Number) as Number
			from dbo.rMaterialRashod as mr
			inner join dbo.rSclad as s on mr.IdSclad = s.Id
			inner join dbo.rMaterialLink as ml on mr.IdMaterialAnalog = ml.IdAnalog
			inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

			Group by s.Id, mo.Id
		) as mr on s.IdSclad = mr.IdSclad and s.IdMaterialOriginal = mr.IdMaterialOriginal

		group by s.IdSclad, s.IdMaterialOriginal
	) as src
	inner join dbo.rSclad as s on src.IdSclad = s.Id

	where src.Number <> 0 --and src.Gorod = N'�������'
	--order by src.IdSclad, src.Number
	) as smon on smo.IdSclad = smon.IdSclad and smo.IdMaterialOriginal = smon.IdMaterialOriginal
) Update C set
Number_tgt = Number_src;
