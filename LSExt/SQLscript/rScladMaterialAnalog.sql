use lansweeperdb;

go

if object_id (N'rScladMaterialAnalog') is null
begin;
	Create table dbo.rScladMaterialAnalog (
		Id int not null identity(1,1) primary key,
		IdSclad int not null,
		Constraint FK_rScladMaterialAnalog foreign key (IdSclad)
			references rSclad(Id),
		IdMaterialAnalog int not null,
		Constraint FK_rScladMaterialAnalog_rMaterialAnalog_IdMaterialAnalog foreign key (IdMaterialAnalog)
			references rMaterialAnalog(Id),
		Number int null,
		NumberInv int null	-- в эту колонку вносим данные инвентаризации при снятии остатков по складам при инвентаризации
	)
end;

if exists (select name from sys.indexes
			where name = N'IX_rScladMaterialAnalog_IdSclad_IdMaterialAnalog')
	begin;
		drop index IX_rScladMaterialAnalog_IdSclad_IdMaterialAnalog on rScladMaterialAnalog

		Create unique index IX_rScladMaterialAnalog_IdSclad_IdMaterialAnalog
		on dbo.rScladMaterialAnalog (IdSclad, IdMaterialAnalog)
	end;
else
	begin;
		Create unique index IX_rScladMaterialAnalog_IdSclad_IdMaterialAnalog
		on dbo.rScladMaterialAnalog (IdSclad, IdMaterialAnalog)
	end;


go

/*
	необходимо добавлять записи материалов которых еще нет 
	периодический запуск в скрипте
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

			/* Суммируем все приходы!!!
			   обязательно для всех 1С позиций которые мы хотим отслеживать должны выполняться условия:
			   1. Номенклатура в расходе должна присуствовать в rMaterialAnalog
			   2. Номенклатура в справочнике должна иметь соответствие в rMaterialAnalog
					в таблицк r1CSprav имеется поле связи IdAnalog int
			   3. Запись из rMaterialAnalog должна быть связана с rMaterialAnalog (через rMaterialLink)
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
				Суммируем перемещения по складу Назначения со статусом перемещения ВЫПОЛНЕНО
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
				where tst.Status like N'В%'

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
				where tst.Status like N'В%'

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

		where src.Number <> 0 --and src.Gorod = N'Иркутск'
		--order by src.IdSclad, src.Number
	) as smon on smo.IdSclad = smon.IdSclad and smo.IdMaterialAnalog = smon.IdMaterialAnalog
) 
Update C set
Number_tgt = Number_src;
