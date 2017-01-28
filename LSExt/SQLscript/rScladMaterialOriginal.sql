use lansweeperdb;

go

if object_id (N'rScladMaterialOriginal') is null
begin;
	Create table dbo.rScladMaterialOriginal (
		Id int not null identity(1,1) primary key,
		IdSclad int not null,
		Constraint FK_rScladMaterialOriginal foreign key (IdSclad)
			references rSclad(Id),
		IdMaterialOriginal int not null,
		Constraint FK_rScladMaterialOriginal_rMaterialOriginal_IdMaterialOriginal foreign key (IdMaterialOriginal)
			references rMaterialOriginal(Id),
		Number int null,
	)
end;

if exists (select name from sys.indexes
			where name = N'IX_rScladMaterialOriginal_IdSclad_IdMaterialOriginal')
	begin;
		drop index IX_rScladMaterialOriginal_IdSclad_IdMaterialOriginal on rScladMaterialOriginal

		Create unique index IX_rScladMaterialOriginal_IdSclad_IdMaterialOriginal
		on dbo.rScladMaterialOriginal (IdSclad, IdMaterialOriginal)
	end;
else
	begin;
		Create unique index IX_rScladMaterialOriginal_IdSclad_IdMaterialOriginal
		on dbo.rScladMaterialOriginal (IdSclad, IdMaterialOriginal)
	end;


go

delete from dbo.rScladMaterialOriginal

go

insert into dbo.rScladMaterialOriginal (
	IdSclad
	, IdMaterialOriginal
	, Number
)

select
	smo.IdSclad
	, smo.IdMaterialOriginal
	, smon.Number
from (
	select 
		s.Id as IdSclad
		, mo.Id as IdMaterialOriginal
	from (
		select 
			s.Id
		from dbo.rSclad as s
	) as s
	cross join (
		select 
			mo.Id
		from dbo.rMaterialOriginal as mo
	) as mo
) as smo
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

	from (
		select 
			s.Id as IdSclad
			, mo.Id as IdMaterialOriginal
		from dbo.rSclad s cross join dbo.rMaterialOriginal mo
	) as s

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