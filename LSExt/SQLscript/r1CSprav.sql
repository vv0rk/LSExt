
use lansweeperdb;

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
				references rMaterialAnalog(Id),
			-- Для каждой позиции справочника привязываем категорию
			[Id1CCategory] int null,
			Constraint FK_r1CSprav_r1CCategory_Id1CCategory_Id foreign key (Id1CCategory)
				references r1CCategory (Id)
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