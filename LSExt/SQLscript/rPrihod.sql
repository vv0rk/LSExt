
use lansweeperdb;

go

if OBJECT_ID (N'rPrihodStatus') is null
	begin;
		Create table rPrihodStatus
		(
			[Id] int not null primary key,
			[Name] nvarchar(20) not null
		)

		insert into dbo.rPrihodStatus(Id,Name) values (1,N'Подготовлено');
		insert into dbo.rPrihodStatus(Id,Name) values (2,N'Проведено');
	end;

-- приходный ордер для приходования товара на склад
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
				references rPrihodStatus(Id),
			[IdCompanyUser] int null, -- это компания которая использует это оборудование
			Constraint FK_rPrihod_rCompany_IdCompanyUser_Id foreign key (IdCompanyUser)
				references rCompany$(Id),
			[IdCompanyOwner] int null, -- это компания которая владеет оборудованием
			Constraint FK_rPrihod_rCompany_IdCompanyOwner_Id foreign key (IdCompanyOwner)
				references rCompany$(Id),
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

if not exists (
			select * 
			from sys.columns 
			where name = N'IdCompanyUser' and Object_ID = Object_ID(N'rPrihod'))
	begin;
		Alter table rPrihod add	[IdCompanyUser] int null; -- это компания которая использует это оборудование
		Alter table rPrihod add Constraint FK_rPrihod_rCompany_IdCompanyUser_Id foreign key (IdCompanyUser) references rCompany$(Id);
		Alter table rPrihod add	[IdCompanyOwner] int null; -- это компания которая владеет оборудованием
		Alter table rPrihod add Constraint FK_rPrihod_rCompany_IdCompanyOwner_Id foreign key (IdCompanyOwner) references rCompany$(Id);
	end;




-- спецификация приходного ордера
-- эта спецификация распадается по категориям (категория определена в справочнике r1CSprav)
if OBJECT_ID (N'rPrihodSpec') is null 
	begin;
		Create table rPrihodSpec
		(
			[Id] int not null identity(1,1) primary key,
			[IdPrihod] int not null,
			Constraint FK_rPrihodSpec_rPrihod_Id foreign key (IdPrihod)	
				references rPrihod(Id),
			[Id1CSprav] int null,
			Constraint FK_rPrihodSpec_r1CSprav_Id foreign key (Id1CSprav)
				references r1CSprav(Id),
			[Nr] int not null,
			-- эта часть необходима когда производится импорт из 1С
			CompanyUser nvarchar(50) null,
			CompanyOwner nvarchar(50) null,
			nrNom nvarchar(50) null,
			Name nvarchar(255) null,
			nrSerial nvarchar(50) null,		-- серийный номер 
			nrInv nvarchar(50) null,			-- инвентарный №
			NrStr nvarchar(10) null


		)
	end;


if not exists (
			select * 
			from sys.columns 
			where name = N'nrNom' and Object_ID = Object_ID(N'rPrihodSpec'))
	begin;
		Alter table rPrihodSpec add CompanyUser nvarchar(50) null;
		Alter table rPrihodSpec add CompanyOwner nvarchar(50) null;

		Alter table rPrihodSpec add nrNom nvarchar(50) null;
		Alter table rPrihodSpec add Name nvarchar(255) null;
		Alter table rPrihodSpec alter column Id1CSprav int null;
		Alter table rPrihodSpec add NrStr nvarchar(10) null;
		Alter table rPrihodSpec add nrSerial nvarchar(50) null;		-- серийный номер 
		Alter table rPrihodSpec add nrInv nvarchar(50) null;		-- инвентарный №

	end;
