use lansweeperdb;

go

-- сформировали записи для справочника номенклатур из прихода
insert into dbo.r1CSprav (nrNom, name, nameLong, IdCompany)
select 
	ps.nrNom as nrNom
	, ps.Name as Name
	, ps.name as NameLong
	, ps.idCompany as idCompany

from (
	select 
		ps.nrNom as nrNom
		, ps.Name as Name
		, ps.name as NameLong
		, c.id as idCompany
	from dbo.rPrihodSpec as ps
	inner join dbo.rCompany$ as c on ps.CompanyOwner = c.Code
	where ps.nrNom is not null and c.id is not null and ps.name is not null
	group by ps.nrNom, ps.Name, c.id
) as ps 
left join dbo.r1CSprav as cs on cs.nrNom = ps.nrNom and cs.IdCompany = ps.idCompany

where cs.nrNom is null

go 

-- обновляем сам приход значениями из справочника номенклатур
with c as(
select 
	ps.nrNom as nrNomTGT
	, cs.nrNom as nrNomSRC
	, ps.Id1CSprav as csTGT
	, cs.Id as csSRC
from dbo.rPrihodSpec as ps
inner join dbo.rCompany$ as c on ps.CompanyOwner = c.Code
inner join dbo.r1CSprav as cs on ps.nrNom = cs.nrNom and c.id = cs.IdCompany

where ps.Id1CSprav != cs.Id or ps.Id1CSprav is null
)
update c set
csTGT = csSRC;


-- проверяем приходы и проверяем что соответствующие записи в справочнике существуют 
-- для не существующих записей Id1CSprav ставим NULL
with c as (
select
	ps.Id1CSprav as Id1CSprav 
	, ps.nrNom as nrNomTGT
	, cs.nrNom as nrNomSRC
	, ps.Id1CSprav as csTGT
	, cs.Id as csSRC
from dbo.rPrihodSpec as ps
left join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id

where cs.nrNom is null and ps.Id1CSprav is not null
) update c set
Id1CSprav = null;


-- Заполняем данные в таблице rActiveCategory1
with c as(
select 
	ac1.nrNom as nrNomTGT
	, cs.nrNom as nrNomSRC
	, ac1.nomName as NameTGT
	, cs.name as NameSRC
from dbo.rActiveCategory1 as ac1
inner join dbo.rPrihodSpec as ps on ac1.IdPrihodSpec = ps.Id
inner join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id
where ac1.nrNom != cs.nrNom or ac1.nomName != cs.name or ac1.nrNom is null or ac1.nomName is null
) update c set
	nrNomTGT = nrNomSRC,
	NameTGT = NameSRC;


-- заполняем данные в rPrihodSpec
with c as(
select 
	ps.nrNom as nrNomTGT
	, cs.nrNom as nrNomSRC
from dbo.rPrihodSpec as ps
inner join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id
where ps.nrNom != cs.nrNom or ps.nrNom is null
) update c set
	nrNomTGT = nrNomSRC;


with c as(
select 
	ps.Name as NameTGT
	, cs.name as NameSRC
from dbo.rPrihodSpec as ps
inner join dbo.r1CSprav as cs on ps.Id1CSprav = cs.Id
where ps.Name != cs.Name or ps.Name is null
) update c set
	NameTGT = NameSRC;