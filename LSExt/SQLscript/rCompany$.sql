
use lansweeperdb;

go

/*
	Консолидируется информация по договорам 
*/

if OBJECT_ID (N'rCompany$') is null
begin;
	create table dbo.rCompany$ (
		Id int not null identity(1,1) primary key,
		[Название организации] nvarchar(255) null,
		[Филиал] nvarchar(255) null,
		Code nvarchar(255) null,		-- код филиала (русский)
		Parent nvarchar(255) null,		-- код родительской организации (русский)
		[Код ENG] nvarchar(50) null,	-- код филиала (английский)
		numPC	int null,				-- количество ПК заявленное ВТшниками
		Comment nvarchar(255) null,
		titleNaumen nvarchar(255) null,
		IdCompanyDogovor int null,
		Constraint FK_rCompany_rCompanyDogovor_IdCompanyDogovor_Id foreign key (IdCompanyDogovor)
			references rCompanyDogovor (Id)
	)
end;


-- добавляем столбец IdCompanyDogovor для связи с таблицей договоров
if not exists (
			select * 
			from sys.columns 
			where name = N'IdCompanyDogovor')
	begin;
		alter table rCompany$ add IdCompanyDogovor int null;
		-- добавляем Constraint 
		alter table rCompany$ add Constraint FK_rCompany_rCompanyDogovor_IdCompanyDogovor_Id foreign key (IdCompanyDogovor)
					references rCompanyDogovor (Id);
	end;

-- добавляем столбец ИНН 
if not exists (
			select * 
			from sys.columns 
			where name = N'INN')
	begin;
		alter table rCompany$ add INN nvarchar(30) null;
		-- добавляем Constraint добавить уникальность невозможно так как не для всех организаций ИНН присутствует
		--alter table rCompany$ add Constraint AK_rCompany_INN Unique(INN);
	end;
