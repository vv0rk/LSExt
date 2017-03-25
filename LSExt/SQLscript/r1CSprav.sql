
use lansweeperdb;

go

-- r1CSprav —правочник материалов и оборудовани€ 1—
if OBJECT_ID (N'r1CSprav') is null
	begin;
		Create table r1CSprav
		(
			[Id] int not null identity(1,1) primary key,
			/* 
				дл€ каждой позиции в номенклатурном справочнике вводим организацию из базы которой получена номенклатура
				также мен€ем уникальные ключи
			*/
			[IdCompany] int null,							
			Constraint FK_r1CSprav_rCompany$_IdCompany_Id foreign key (IdCompany)
				references rCompany$ (Id),
			[nrNom] nvarchar(50) null,
			Constraint AK_r1CSprav_nrNom Unique(IdCompany, nrNom),
			-- инвентарного є в приходе нет
			--[nrInv] nvarchar(50) null,
			--Constraint AK_r1CSprav_nrInv Unique(nrInv),
			[name]  nvarchar(255) not null,
			[nameLong] nvarchar(255) not null,
			-- кажда€ позици€ в справочнике 1— прив€зываетс€ к аналогу однозначно.
			[IdAnalog] int null,
			Constraint FK_r1CSprav_rMaterialAnalog_Id foreign key (IdAnalog)
				references rMaterialAnalog(Id),
			-- ƒл€ каждой позиции справочника прив€зываем категорию
			[Id1CCategory] int null,
			Constraint FK_r1CSprav_r1CCategory_Id1CCategory_Id foreign key (Id1CCategory)
				references r1CCategory (Id),
			--[IdPrihodSpec] int null -- включаем дл€ того чтобы зафиксировать откуда пришло значение в справочник (не об€зательно)
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

if not exists (
			select * 
			from sys.columns 
			where name = N'Id1CCategory' and Object_ID = Object_ID(N'r1CSprav'))
	begin;
		Alter table r1CSprav add Id1CCategory Int Null;
		Alter table r1CSprav add Constraint FK_r1CSprav_r1CCategory_Id1CCategory_Id foreign key (Id1CCategory)
				references r1CCategory (Id);
	end;



if not exists (
			select * 
			from sys.columns 
			where name = N'IdCompany' and Object_ID = Object_ID(N'r1CSprav'))
	begin;
		Alter table r1CSprav add IdCompany Int Null;
		Alter table r1CSprav add Constraint FK_r1CSprav_rCompany$_IdCompany_Id foreign key (IdCompany)
				references rCompany$ (Id);

		Alter table r1CSprav drop Constraint AK_r1CSprav_nrNom;
		Alter table r1CSprav add Constraint AK_r1CSprav_nrNom UNIQUE(IdCompany, nrNom);

		-- удалил это ограничение так как у бухов есть ошибки в одной конторе одно им€ дл€ разных номенклатур
		--Alter table r1CSprav drop Constraint AK_r1CSprav_name;
		--Alter table r1CSprav add Constraint AK_r1CSprav_name Unique(IdCompany, name);
	end;


Alter table r1CSprav drop Constraint AK_r1CSprav_name;
