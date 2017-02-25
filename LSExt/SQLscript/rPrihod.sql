
use lansweeperdb;

go

if OBJECT_ID (N'rPrihodStatus') is null
	begin;
		Create table rPrihodStatus
		(
			[Id] int not null primary key,
			[Name] nvarchar(20) not null
		)

		insert into dbo.rPrihodStatus(Id,Name) values (1,N'ѕодготовлено');
		insert into dbo.rPrihodStatus(Id,Name) values (2,N'ѕроведено');
	end;

-- приходный ордер дл€ приходовани€ товара на склад
if OBJECT_ID (N'rPrihod') is null
	begin;
		Create table rPrihod
		(
			[Id] int not null identity(1,1) primary key,
			[IdSclad] int not null,
			Constraint FK_rPrihod_rSclad_Id foreign key (IdSclad)
				references rSclad(Id),
			[Number] nvarchar(20) not null,
			[Date] datetime not null,
			[IdStatus] int not null default 1,
			Constraint FK_rPrihod_rPrihodStatus_IdStatus_Id foreign key (IdStatus)
				references rPrihodStatus(Id)
		)
	end;

if not exists (
			select * 
			from sys.columns 
			where name = N'IdStatus' and Object_ID = Object_ID(N'rPrihod'))
	begin;
		Alter table rPrihod add IdStatus int not null default 1;
		Alter table rPrihod add Constraint FK_rPrihod_rPrihodStatus_IdStatus_Id foreign key (IdStatus)
				references rPrihodStatus(Id);
	end;

-- спецификаци€ приходного ордера
-- эта спецификаци€ распадаетс€ по категори€м (категори€ определена в справочнике r1CSprav)
if OBJECT_ID (N'rPrihodSpec') is null 
	begin;
		Create table rPrihodSpec
		(
			[Id] int not null identity(1,1) primary key,
			[IdPrihod] int not null,
			Constraint FK_rPrihodSpec_rPrihod_Id foreign key (IdPrihod)	
				references rPrihod(Id),
			[Id1CSprav] int not null,
			Constraint FK_rPrihodSpec_r1CSprav_Id foreign key (Id1CSprav)
				references r1CSprav(Id),
			[Nr] int not null
		)
	end;
