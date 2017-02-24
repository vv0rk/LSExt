
use lansweeperdb;

go

/*
	Консолидируется информация по договорам 
*/

if OBJECT_ID (N'rCompanyDogovor') is null
begin;
	create table dbo.rCompanyDogovor (
		Id int not null identity(1,1) primary key,
		Name nvarchar(100) null,	-- наименование организации 
		Number nvarchar(50) null,	-- номер договора
		DateStart datetime null,	-- дата начала договора
		DateDS int null, -- месяц в который предусматривается пересмотр договора
	)
end;