use lansweeperdb;

go

Create table rTonerModelLSW (
	Id int not null identity(1,1) primary key,
	TonerName nvarchar(100) not null,
	TonerColorName nvarchar(50) null,
	idModelDevice int not null,

	Constraint FK_rTonerModelLSW_rModelDevice_id foreign key (idModelDevice)
		references rModelDevice (Id)
)


-- скрипт для добавления записей в таблицу rTonerModelLSW


