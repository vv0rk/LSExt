use lansweeperdb;

go

/*
	скрипт для синхронизации данных
*/


-- добавление новых записей в таблицы
insert into dbo.rOUMod (removed, title, case_id, IdrOU, idparent_id)
select 
	ro.removed,
	ro.title,
	ro.case_id,
	ro.id,
	ro.parent_id

from rOU as ro
left join rOUMod as rom on ro.id = rom.IdrOU
where rom.Id is null

insert into dbo.rEmployeeMod( removed, title, post, parent_id, IdrEmployee, idparent_id)
select 
	e.removed
	, e.title
	, e.post
	, rom.Id
	, e.id
	, e.parent_id
from rEmployee as e 
left join rOUMod as rom on e.parent_id = rom.IdrOU
left join rEmployeeMod as em on e.id = em.IdrEmployee

where em.Id is null

