use lansweeperdb;

go

insert into dbo.rShtatR (oldId, Company, Filial, Departament, Upravlenie, Otdel, Grupa, Dolgnost)
select 
	p.id as oldId
	, p.Company as Company
	, p.Filial as Filial
	, p.Departament as Departament
	, p.Upravlenie as Upravlenie
 	, p.Otdel as Otdel
	, p.Grupa as Grupa
	, p.Dolgnost

from dbo.rPersonal as p
