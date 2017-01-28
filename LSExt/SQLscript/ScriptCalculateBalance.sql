
use lansweeperdb;

/*
	Script для пересчета баланса
*/

go


/*
	Рассчет по складу rScladMaterialOriginal
*/
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
		-- pr + pt - rt - mr
		, isnull(sum(pr.Number),0) + isnull(sum(pt.Number),0) - isnull(sum(rt.Number),0) - isnull(sum(mr.Number),0) as Number

	from (
		select 
			s.Id as IdSclad
			, mo.Id as IdMaterialOriginal
		from dbo.rSclad s cross join dbo.rMaterialOriginal mo
	) as s

	/* Суммируем все приходы!!!
	   обязательно для всех 1С позиций которые мы хотим отслеживать должны выполняться условия:
	   1. Номенклатура в расходе должна присуствовать в r1CSprav
	   2. Номенклатура в справочнике должна иметь соответствие в rMaterialAnalog
			в таблицк r1CSprav имеется поле связи IdAnalog int
	   3. Запись из rMaterialAnalog должна быть связана с rMaterialOriginal (через rMaterialLink)
	*/ 
	left join (
		select 
			s.Id as IdSclad
			, mo.PartNumber
			, mo.Id as IdMaterialOriginal
			, sum(ps.Nr) as Number
		from dbo.rPrihod as p
		inner join dbo.rPrihodSpec as ps on p.Id = ps.IdPrihod
		inner join dbo.rSclad as s on p.IdSclad = s.Id
		inner join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id
		inner join dbo.rMaterialAnalog as ma on cs.IdAnalog = ma.Id
		inner join dbo.rMaterialLink as ml on ma.Id = ml.IdAnalog
		inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

		group by s.Id, mo.Id, mo.PartNumber
	) as pr on s.IdSclad = pr.IdSclad and s.IdMaterialOriginal = pr.IdMaterialOriginal

	/*
		Суммируем перемещения по складу Назначения со статусом перемещения ВЫПОЛНЕНО
		на целевые склады
	*/
	left join (
		select 
			s.Id as IdSclad
			, mo.Id as IdMaterialOriginal
			, mo.PartNumber as PartNumber
			, sum (ts.Number) as Number

		from dbo.rTransfer as t
		inner join dbo.rSclad as s on t.IdScladTarget = s.Id
		inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
		inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
		inner join dbo.r1CSprav as cs on ts.Id1CSprav = cs.Id
		inner join dbo.rMaterialAnalog as ma on cs.IdAnalog = ma.Id
		inner join dbo.rMaterialLink as ml on ma.Id = ml.IdAnalog
		inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

		where tst.Status like N'В%'

		Group by s.Id, mo.Id, mo.PartNumber 
	) as pt on s.IdSclad = pt.IdSclad and s.IdMaterialOriginal = pt.IdMaterialOriginal

	/*
		Суммируем перемещения по складу Источника со статусом перемещения ВЫПОЛНЕНО
		на целевые склады
		будет использоваться для вычета из запаса на складе
	*/
	left join (
		select 
			s.Id as IdSclad
			, mo.Id as IdMaterialOriginal
			, mo.PartNumber as PartNumber
			, sum (ts.Number) as Number

		from dbo.rTransfer as t
		inner join dbo.rSclad as s on t.IdScladSource = s.Id
		inner join dbo.rTransferSpec as ts on t.Id = ts.IdTransfer
		inner join dbo.rTransferStatus as tst on t.IdStatus = tst.Id
		inner join dbo.r1CSprav as cs on ts.Id1CSprav = cs.Id
		inner join dbo.rMaterialAnalog as ma on cs.IdAnalog = ma.Id
		inner join dbo.rMaterialLink as ml on ma.Id = ml.IdAnalog
		inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

		where tst.Status like N'В%'

		Group by s.Id, mo.Id, mo.PartNumber 
	) as rt on s.IdSclad = rt.IdSclad and s.IdMaterialOriginal = rt.IdMaterialOriginal

	/* 
		Суммируем все операции расхода со склада
		вычитается из склада источника
	*/
	left join (
		select 
			s.Id as IdSclad
			, mo.Id as IdMaterialOriginal
			, mo.PartNumber as PartNumber
			, sum (mr.Number) as Number
		from dbo.rMaterialRashod as mr
		inner join dbo.rSclad as s on mr.IdSclad = s.Id
		inner join dbo.rMaterialLink as ml on mr.IdMaterialAnalog = ml.IdAnalog
		inner join dbo.rMaterialOriginal as mo on ml.IdOriginal = mo.Id

		Group by s.Id, mo.Id, mo.PartNumber
	) as mr on s.IdSclad = mr.IdSclad and s.IdMaterialOriginal = mr.IdMaterialOriginal

	group by s.IdSclad, s.IdMaterialOriginal

) as src

inner join dbo.rSclad as s on src.IdSclad = s.Id

where src.Number <> 0 --and src.Gorod = N'Иркутск'
--order by src.IdSclad, src.Number
) as smon on smo.IdSclad = smon.IdSclad and smo.IdMaterialOriginal = smon.IdMaterialOriginal


/*
*/

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