use lansweeperdb;

go

/*
	этот скрипт обновляет номенклатуру по складам
*/

-- обновление номенклатуры 1С
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

-- обновление номенклатуры MaterialOriginal
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

go

-- обновление номенклатуры MaterialAnalog
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
