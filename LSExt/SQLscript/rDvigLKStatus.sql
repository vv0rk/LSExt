use lansweeperdb;

go

/*
	Состояние транзакций перемещения
	1 - перемещение начато
	2 - перемещение завершено
*/

if object_id (N'rDvigLKStatus') is null
begin;
	CREATE TABLE [dbo].rDvigLKStatus
	(
		[Id] INT NOT NULL PRIMARY KEY,	
		
		-- Статус транзакции 
		[StatusName] nvarchar(20) not null
	);
end;

insert into rDvigLKStatus (Id, StatusName) Values (1, N'Старт');
insert into rDvigLKStatus (Id, StatusName) Values (2, N'Финиш');
