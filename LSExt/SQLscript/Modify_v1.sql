use lansweeperdb;

-- эти изменени€ 08.01.2017 
-- —оздаем 3 таблицы rSclad1C, rScladOriginal, rScladAnalog
-- кажда€ таблица представл€ет собой декартово производение таблицы rSclad и одной из таблиц
-- r1CSprav, rMaterialOriginal, rMaterialAnalog
-- кажда€ из таблиц состоит из 4х столбцов
-- Id, IdSclad, IdXXXXXX, Number
-- эти таблицы нос€т вспомогательный характер текущих складов

-- действи€ измен€ющие значени€ в этих таблицах
-- ѕриход, ѕеремещение, –асход

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- вс€ номенклатура 1— по складам
Create table rSclad1C 
(
	[Id] int not null identity(1,1) primary key,
	[IdSclad] int not null,
	Constraint FK_rSclad1C_rSclad_IdSclad foreign key (IdSclad)
		references rSclad(Id),
	[Id1CSprav] int not null,
	Constraint FK_rSclad1C_r1CSprav_Id1CSprav foreign key (Id1CSprav)
		references r1CSprav(Id),
	
	[Total] int not null default 0
)

-- вс€ номенклатура јналог по складам
Create table rScladAnalog
(
	[Id] int not null identity(1,1) primary key,
	[IdSclad] int not null,
	Constraint FK_rScladAnalog_rSclad_IdSclad foreign key (IdSclad)
		references rSclad(Id),
	[IdMaterialAnalog] int not null,
	Constraint FK_rScladAnalog_rMaterialAnalog_IdMaterialAnalog foreign key (IdMaterialAnalog)
		references rMaterialAnalog(Id),

	[Total] int not null default 0
)

-- вс€ номенклатура Original по складам
Create table rScladOriginal
(
	[Id] int not null identity(1,1) primary key,
	[IdSclad] int not null,
	Constraint FK_rScladOriginal_rSclad_IdSclad foreign key (IdSclad)
		references rSclad(Id),
	[IdMaterialOriginal] int not null,
	Constraint FK_rScladOriginal_rMaterialOriginal_IdMaterialOriginal foreign key (IdMaterialOriginal)
		references rMaterialOriginal(Id),

	[Total] int not null default 0
)

----------- ƒобавл€ем триггеры которые будут обрабатывать обновление этих таблиц ------------------

