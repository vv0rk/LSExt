use lansweeperdb;

go

if object_id (N'rSclad1CSprav') is null
begin;
	Create table dbo.rSclad1CSprav (
		Id int not null identity(1,1) primary key,
		IdSclad int not null,
		Constraint FK_rSclad1CSprav foreign key (IdSclad)
			references rSclad(Id),
		Id1CSprav int not null,
		Constraint FK_rSclad1CSprav_r1CSprav_Id1CSprav foreign key (Id1CSprav)
			references r1CSprav(Id),
		Number int null,
	)
end;

if exists (select name from sys.indexes
			where name = N'IX_rSclad1CSprav_IdSclad_Id1CSprav')
	begin;
		drop index IX_rSclad1CSprav_IdSclad_Id1CSprav on rSclad1CSprav

		Create unique index IX_rSclad1CSprav_IdSclad_Id1CSprav
		on dbo.rSclad1CSprav (IdSclad, Id1CSprav)
	end;
else
	begin;
		Create unique index IX_rSclad1CSprav_IdSclad_Id1CSprav
		on dbo.rSclad1CSprav (IdSclad, Id1CSprav)
	end;


go

delete from dbo.rSclad1CSprav

go


insert into dbo.rSclad1CSprav (
	IdSclad
	, Id1CSprav
	, Number
)

select
	smo.IdSclad
	, smo.Id1CSprav
	, smon.Number
from (
	select 
		s.Id as IdSclad
		, mo.Id as Id1CSprav
	from (
		select 
			s.Id
		from dbo.rSclad as s
	) as s
	cross join (
		select 
			mo.Id
		from dbo.r1CSprav as mo
	) as mo
) as smo
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

	from (
		select 
			s.Id as IdSclad
			, mo.Id as Id1CSprav
		from dbo.rSclad s cross join dbo.r1CSprav mo
	) as s

	/* Суммируем все приходы!!!
	   обязательно для всех 1С позиций которые мы хотим отслеживать должны выполняться условия:
	   1. Номенклатура в расходе должна присуствовать в r1CSprav
	   2. Номенклатура в справочнике должна иметь соответствие в rMaterialAnalog
			в таблицк r1CSprav имеется поле связи IdAnalog int
	   3. Запись из rMaterialAnalog должна быть связана с r1CSprav (через rMaterialLink)
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
		Суммируем перемещения по складу Назначения со статусом перемещения ВЫПОЛНЕНО
		на целевые склады
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

		where tst.Status like N'В%'

		Group by s.Id, cs.Id, cs.nrNom 
	) as pt on s.IdSclad = pt.IdSclad and s.Id1CSprav = pt.Id1CSprav

	/*
		Суммируем перемещения по складу Источника со статусом перемещения ВЫПОЛНЕНО
		на целевые склады
		будет использоваться для вычета из запаса на складе
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

		where tst.Status like N'В%'

		Group by s.Id, cs.Id, cs.nrNom 
	) as rt on s.IdSclad = rt.IdSclad and s.Id1CSprav = rt.Id1CSprav

	/* 
		Суммируем все операции расхода со склада
		вычитается из склада источника
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

where src.Number <> 0 --and src.Gorod = N'Иркутск'
--order by src.IdSclad, src.Number
) as smon on smo.IdSclad = smon.IdSclad and smo.Id1CSprav = smon.Id1CSprav