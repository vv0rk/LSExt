use lansweeperdb;

go

/*
	статус определяет можно ли оценивать количество обслуживаемого ПО по числу установок
	Локальная - да можно оценивать
	Удаленная - нет, для определения числа обслуживаемый единиц необходимо оценивать по логам
	подключается к каталогу
	используется при формировании отчета по количеству обслуживаемых экземпляров (Рипп)
*/

if object_id (N'rCatalogUslugStatus') is null
begin;
	CREATE TABLE [dbo].rCatalogUslugStatus
	(
		[Id] INT NOT NULL PRIMARY KEY,		
		-- название позиции каталога программ
		[Status] NVARCHAR(50) NOT NULL, 
		Constraint AK_rCatalogUslugStatus_Status Unique(Status),
	);
end;

insert into [dbo].rCatalogUslugStatus ( Id, Status ) Values ( 1, N'Локальная');
insert into [dbo].rCatalogUslugStatus ( Id, Status ) Values ( 2, N'Удаленная');

