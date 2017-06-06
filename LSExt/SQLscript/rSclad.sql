
use lansweeperdb;

go

/*
склад на котором может происходить накопление ТМЦ
*/

if object_id (N'rSclad') is null
begin;
	Create table dbo.rSclad (
		Id int not null identity(1,1) primary key,
		Company nvarchar(100) not null,
		Gorod nvarchar(50) not null,
		Address nvarchar(255) not null,
		Respons nvarchar(100) not null,
		ScladName nvarchar(100) not null
	)
end;