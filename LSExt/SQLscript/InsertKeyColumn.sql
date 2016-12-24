use lansweeperdb;

go

alter table rShtatR drop column id
alter table rShtatR add id int identity(1,1) not null Primary key


alter table rCompany$
drop column id 

alter table dbo.rCompany$
add id int identity(1,1) not null Primary key


-- Вставляем столбец для количества ПК которые обслуживаются организацией
alter table dbo.rCompany$
add numPC int null

-- Вставляем столбец для количества ПК которые обслуживаются организацией
alter table dbo.rCompany$
add Comment nvarchar(255) null