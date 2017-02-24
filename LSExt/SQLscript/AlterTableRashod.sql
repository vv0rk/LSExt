use lansweeperdb;

-- эти изменения 06.01.2017 применяются на продакшн сервере Lansweeper

/****** Object:  Trigger [dbo].[Trigger_Create]    Script Date: 17.12.2016  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- модификация таблицы rMaterialLink
if object_id (N'rMaterialLink') is not null
	begin; 
		if not exists (select name from sys.indexes where name = N'IX_rMaterialLink_IdOriginal_IdAnalod' )
			begin;
				-- Уникальный для связки Оригинальный - Аналог
				Create Unique nonclustered index IX_rMaterialLink_IdOriginal_IdAnalod on rMaterialLink (IdOriginal, IdAnalog);
			end;
		else 
			begin;
				-- Уникальный для связки Оригинальный - Аналог
				drop index IX_rMaterialLink_IdOriginal_IdAnalod on rMaterialLink
				Create Unique nonclustered index IX_rMaterialLink_IdOriginal_IdAnalod on rMaterialLink (IdOriginal, IdAnalog);
			end;
	end;
else 
	begin;
		-- Таблица сопоставления оригинальных материалов и аналогов
		-- используется при проверке назначения аналога материала на устройство
		CREATE TABLE rMaterialLink
		(
			[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
			[IdOriginal]	INT NOT NULL,
			[IdAnalog]		INT NOT NULL,

			--Constraint FK_rMaterialOriginal_rMaterialLink_Id FOREIGN KEY (idOriginal)
			--	References rMaterialOriginal (Id),
			-- Если удаляем запись в rMaterialAnalog то удаляются все связанные записи в этой таблице
			Constraint FK_rMaterialAnalog_rMaterialLink_Id FOREIGN KEY (IdAnalog)
				References rMaterialAnalog (Id)
				on DELETE CASCADE
		)
		-- Некластеризованный составной индекс
		-- Уникальный для связки Оригинальный - Аналог
		Create Unique nonclustered index IX_rMaterialLink_IdOriginal_IdAnalod on dbo.lansweeperdb.rMaterialLink (IdOriginal, IdAnalog);
	end;
go

-- таблица rModelLink
-- связь моделей, которые определяются в Lansweeper и справочных значений моделей
if object_id (N'rModelLink') is null
	begin; 
		-- Сопоставление модели распознанной и модели из справочника
		CREATE TABLE rModelLink
		(
			[Id] INT Not null identity(1,1) primary key,
			-- заполняется из AssetCustom.Model с distinct
			ModelAsset nvarchar(255) null,		
				Constraint AK_ModelAsset Unique(ModelAsset),
			-- заполняется из rModelDevice и потом пишется в AssetCustom9
			ModelSprav nvarchar(255) null,
				Constraint FK_rModelLink_rModelDevice_Model foreign key (ModelSprav)
					references rModelDevice(Model)
					on update Cascade
		);
		Create Unique nonclustered index IX_rModelLink_ModelAsset_ModelSprav on rModelLink (ModelAsset, ModelSprav);
	end;
else 
	begin;
		drop index IX_rMaterialLink_IdOriginal_IdAnalod on rMaterialLink
		Create Unique nonclustered index IX_rMaterialLink_IdOriginal_IdAnalod on rMaterialLink (IdOriginal, IdAnalog);
		
	end;
go

-- В этом скрипте обрабатываем изменения существующих таблиц
drop trigger dbo.Trigger_rMaterialRashod_Insert

go

create trigger trigger_rmaterialrashod_insert
on [dbo].[rmaterialrashod] for insert
as
begin;
	-- set nocount on added to prevent extra result sets from
	-- interfering with select statements.
	set nocount on;

	Declare @Msg varchar(8000)
	set @Msg = N'Ошибка при назначении материала на устройство. Проверить комплект'

	-- проверяем правильность назначения материала на устройство
		if not exists (select 
			mr.id
		from inserted as mr
		inner join dbo.rmateriallink as ml on mr.idmaterialanalog = ml.idanalog
		inner join dbo.rmodelcomplect as mc on ml.idoriginal = mc.idmaterialoriginal
		inner join dbo.rmodeldevice as md on mc.idmodel = md.id
		inner join dbo.tblassetcustom as ac on mr.assetid = ac.assetid

		where md.model = ac.model
		)
		begin;
			raiserror(50005,10,1,@Msg)
			rollback transaction
		end;

	insert into 
		[dbo].rsetrmhist
		(
			assetid,
			custom1,
			custom2,
			custom3,
			custom4,
			custom5,
			[date],
			idmaterialanalog
		)
		select
			i.assetid,
			ac.custom1,
			ac.custom2,
			ac.custom3,
			ac.custom4,
			ac.custom5,
			i.date,
			i.idmaterialanalog
		from inserted as i
		inner join dbo.tblassetcustom as ac on i.assetid = ac.assetid

	insert into 
		[dbo].rsetprinthist
		(
			assetid,
			company,
			city,
			[address],
			officenr,
			placenr,
			datecheck,
			printedpages
		)
		select
			i.assetid,
			ac.custom1,
			ac.custom2,
			ac.custom3,
			ac.custom4,
			ac.custom5,
			i.date,
			i.printedpages
		from inserted as i
		inner join dbo.tblassetcustom as ac on i.assetid = ac.assetid

end;

go
-- r1CSprav Справочник материалов и оборудования 1С
if OBJECT_ID (N'r1CSprav') is null
	begin;
		Create table r1CSprav
		(
			[Id] int not null identity(1,1) primary key,
			[nrNom] nvarchar(50) null,
			Constraint AK_r1CSprav_nrNom Unique(nrNom),
			-- инвентарного № в приходе нет
			--[nrInv] nvarchar(50) null,
			--Constraint AK_r1CSprav_nrInv Unique(nrInv),
			[name]  nvarchar(255) not null,
			Constraint AK_r1CSprav_name Unique(name),
			[nameLong] nvarchar(255) not null,
			-- каждая позиция в справочнике 1С привязывается к аналогу однозначно.
			[IdAnalog] int null,
			Constraint FK_r1CSprav_rMaterialAnalog_Id foreign key (IdAnalog)
				references rMaterialAnalog(Id)
		)

		--Create table rAnalog1CSpravLink
		--(
		--	[Id] int not null identity(1,1) primary key,
		--	[IdAnalog] int not null,
		--	Constraint FK_rAnalog1CSpravLink_rMaterialAnalog_Id foreign key (IdAnalog)
		--		references rMaterialAnalog(Id),
		--	[Id1CSprav] int not null,
		--	Constraint FK_rAnalog1CSpravLink_r1CSprav_Id foreign key (Id1CSprav)
		--		references r1CSprav(Id)
		--)
		--Create Unique nonclustered index IX_rAnalog1CSpravLink_IdAnalog_Id1CSprav on rAnalog1CSpravLink (IdAnalog, Id1CSprav)
	end;

-- определяем склады которые используются
if OBJECT_ID (N'rSclad') is null
	begin;
		Create table rSclad
		(
			[Id] int not null identity(1,1) primary key,
			[Company] nvarchar(100) not null,
			[Gorod] nvarchar(50) not null,
			[Address] nvarchar(255) not null,
			[Respons] nvarchar(100) not null
		)
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
			[Date] datetime not null
		)
	end;

-- спецификация приходного ордера
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

-- модификация rMaterialRashod
if not exists (
			select * 
			from sys.columns 
			where name = N'Number' and Object_ID = Object_ID(N'rMaterialRashod'))
	begin;
		Alter table rMaterialRashod add Number Int Not Null default 1
	end;

if OBJECT_ID (N'rMaterialRashod.IdSclad') is null
	begin;
		Alter table rMaterialRashod add IdSclad Int Not Null default 1
		Constraint FK_rMaterialRashod_rSclad_IdSclad foreign key (IdSclad)
			References rSclad(Id)
	end;

-- добавляем столбец расчетный сколько картридж отходил
if OBJECT_ID (N'rMaterialRashod.ResourceFact') is null
	begin;
		Alter table rMaterialRashod add ResourceFact Int Null
	end;

go

if OBJECT_ID (N'rUser') is null
	begin;
		Create table rUser
		(
			Id int not null identity(1,1) primary key,
			UserName varchar(100) unique
		)		
	end;

go


-- определяет статус проводки 
-- Заявка, Выдано
if OBJECT_ID (N'rTransferStatus') is null
	begin;
		Create table rTransferStatus
		(
			Id int not null identity(1,1) primary key,
			[Status] nvarchar(50) not null default N'Заявка',
		)
	end;

-- В зависимости от текущего статуса перемещения по складам 
-- перемещение может быть закрыто для дальнейшего использования 
-- и для участия в расчетах 
-- Статус Заявка - в триггерах и в рассчетах никак не участвуют, редактирование разрешено
-- Статус Выдано - в триггерах запрещено редактирование заявки. Данные участвуют в рассчетах остатков по складам.
if OBJECT_ID (N'rTransfer') is null
	begin;
		Create table rTransfer
		(
			Id int not null identity(1,1) primary key,
			[IdScladSource] int not null,
			Constraint FK_rTransfer_rSclad_IdScladSource_Id foreign key (IdScladSource)
				references rSclad(Id),
			[IdScladTarget] int not null,
			Constraint FK_rTransfer_rSclad_IdScladTarger_Id foreign key (IdScladTarget)
				references rSclad(Id),
			[Number] nvarchar(20) not null,
			[Date] datetime not null default getdate(),
			[IdStatus] int not null,
			Constraint FK_rTransfer_rTransferStatus_Id foreign key (IdStatus)
				references rTransferStatus(Id),
			[IdUserCreate] int null
				Constraint FK_rUser_rTransfer_idUserCreate foreign key (IdUserCreate)
					references rUser(Id),
			[DateCreation] datetime not null default getdate(),
			[IdUserUpdate] int null
				Constraint FK_rUser_rTransfer_idUserUpdate foreign key (IdUserUpdate)
					references rUser(Id),
			[DateUpdate] datetime not null default getdate()
		)
	end;

if OBJECT_ID (N'rTransferSpec') is null
	begin;
		Create table rTransferSpec
		(
			Id int not null identity(1,1) primary key,
			[IdTransfer] int not null,
			Constraint FK_rTransferSpec_rTransfer_IdTransfer foreign key (IdTransfer)
				references rTransfer(Id)
				on delete cascade,
			[IdOriginal] int not null,
			Constraint FK_rTransfer_rOriginal_IdOriginal foreign key (IdOriginal)
				references rMaterialOriginal(Id),


			[Number] int not null,

			[IdUserCreate] int null
				Constraint FK_rUser_rTransferSpec_idUserCreate foreign key (IdUserCreate)
					references rUser(Id),
			[DateCreation] datetime not null default getdate(),
			[IdUserUpdate] int null 
				Constraint FK_rUser_rTransferSpec_idUserUpdate foreign key (IdUserUpdate)
					references rUser(Id),
			[DateUpdate] datetime not null default getdate()
		)
	end;

go

drop trigger dbo.Trigger_rTransfer_Insert
drop trigger dbo.Trigger_rTransfer_Update
drop trigger dbo.Trigger_rTransferSpec_Insert
drop trigger dbo.Trigger_rTransferSpec_Update

go

Create trigger Trigger_rTransfer_Insert on dbo.rTransfer for insert
as
	begin;
		Declare @user nvarchar(100)
		declare @iduser int
		declare @status nvarchar(50)

		set @status = (
			select ts.Status
			from deleted as i
			inner join dbo.rTransferStatus as ts on i.IdStatus = ts.Id )

		if (@status = N'Выполнено') 
			begin;
				rollback transaction
			end;



		set @user = USER_NAME()
		if not exists (select * from dbo.rUser as u where u.UserName = @user ) 
			begin;
				Insert into dbo.rUser (UserName) values ( @user )
			end;

		set @iduser = (select u.Id from dbo.rUser as u where u.UserName = @user);

		with c as (
			select 
				t.IdUserCreate as UserCreate,
				t.IdUserUpdate as UserUpdate
			from inserted as i
			inner join dbo.rTransfer as t on i.Id = t.Id
		) update c set
		UserCreate = @iduser,
		UserUpdate = @iduser;
	end;

go 

Create trigger Trigger_rTransfer_Update on dbo.rTransfer for Update
as
	begin;
		Declare @user nvarchar(100)
		declare @iduser int
		declare @idusercreate int

		------------ часть кода зависящая от статуса -------------
 		declare @status nvarchar(50)

		set @status = (
			select ts.Status
			from deleted as i
			inner join dbo.rTransferStatus as ts on i.IdStatus = ts.Id )

		if (@status = N'Выполнено') 
			begin;
				rollback transaction
			end;
		------------ часть кода зависящая от статуса -------------

		set @user = USER_NAME();
		if not exists (select * from dbo.rUser as u where u.UserName = @user ) 
			begin;
				Insert into dbo.rUser (UserName) values ( @user )
			end;

		set @iduser = (select u.Id from dbo.rUser as u where u.UserName = @user);

		set @idusercreate = (select d.IdUserCreate from deleted as d );
		if @idusercreate is null
			begin;
				set @idusercreate = @iduser
			end;

		with c as (
			select 
				t.IdUserCreate as UserCreate,
				t.IdUserUpdate as UserUpdate
			from inserted as i
			inner join deleted as d on i.Id = d.Id
			inner join dbo.rTransfer as t on i.Id = t.Id
		) update c set
		UserCreate = @IdUserCreate,
		UserUpdate = @idUser;
	end;

go

Create trigger Trigger_rTransferSpec_Insert on [dbo].[rTransferSpec] for insert
as
	begin;
		Declare @user nvarchar(100)
		declare @iduser int
		declare @idusercreate int

		------------ часть кода зависящая от статуса -------------
 		declare @status nvarchar(50)

		set @status = (
			select ts.Status
			from inserted as i
			inner join dbo.rTransfer as t on i.IdTransfer = t.Id
			inner join dbo.rTransferStatus as ts on t.IdStatus = ts.Id )

		if (@status = N'Выполнено') 
			begin;
				rollback transaction
			end;
		------------ часть кода зависящая от статуса -------------


		set @user = USER_NAME();
		if not exists (select * from dbo.rUser as u where u.UserName = @user ) 
			begin;
				Insert into dbo.rUser (UserName) values ( @user )
			end;

		set @iduser = (select u.Id from dbo.rUser as u where u.UserName = @user);

		set @idusercreate = (select d.IdUserCreate from deleted as d );
		if @idusercreate is null
			begin;
				set @idusercreate = @iduser
			end;

		with c as (
			select 
				t.IdUserCreate as UserCreate,
				t.IdUserUpdate as UserUpdate
			from inserted as i
			inner join deleted as d on i.Id = d.Id
			inner join dbo.rTransferSpec as t on i.Id = t.Id
		) update c set
		UserCreate = @IdUserCreate,
		UserUpdate = @idUser;
	end;

go 

Create trigger Trigger_rTransferSpec_Update on dbo.rTransferSpec for Update
as
	begin;
		Declare @user nvarchar(100)
		declare @iduser int
		declare @idusercreate int

		------------ часть кода зависящая от статуса -------------
 		declare @status nvarchar(50)

		set @status = (
			select ts.Status
			from inserted as i
			inner join dbo.rTransfer as t on i.IdTransfer = t.Id
			inner join dbo.rTransferStatus as ts on t.IdStatus = ts.Id )

		if (@status = N'Выполнено') 
			begin;
				rollback transaction
			end;
		------------ часть кода зависящая от статуса -------------



		set @user = USER_NAME();
		if not exists (select * from dbo.rUser as u where u.UserName = @user ) 
			begin;
				Insert into dbo.rUser (UserName) values ( @user )
			end;

		set @iduser = (select u.Id from dbo.rUser as u where u.UserName = @user);

		set @idusercreate = (select d.IdUserCreate from deleted as d );
		if @idusercreate is null
			begin;
				set @idusercreate = @iduser
			end;

		with c as (
			select 
				t.IdUserCreate as UserCreate,
				t.IdUserUpdate as UserUpdate
			from inserted as i
			inner join deleted as d on i.Id = d.Id
			inner join dbo.rTransferSpec as t on i.Id = t.Id
		) update c set
		UserCreate = @IdUserCreate,
		UserUpdate = @idUser;
	end;