use lansweeperdb;

go

/*
	для работы через Access создаем копии таблиц rEmployee и rOU
	rEmployeeMod, rOUMod
	синхронизироваться данные будут в них по скрипту
*/

if object_id (N'rOUMod') is null
begin;
	CREATE TABLE [dbo].rOUMod
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		[removed] bit not null default 0,
		[title] nvarchar(4000) null,
		[case_id] nvarchar(255) null,
		[parent_id] int null, -- ссылка на вновь созданную таблицу rOUMod
		-- связь с родительскими записями
		[IdrOU] bigint not null, 
		[idparent_id] bigint null
	);
end;

if object_id (N'rEmployeeMod') is null
begin;
	CREATE TABLE [dbo].rEmployeeMod
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		[removed] bit not null default 0,
		[title] nvarchar(4000) null,
		[post] nvarchar(255) null,
		[parent_id] int null, -- ссылка на вновь созданную таблицу rOUMod
		-- связь с родительскими записями
		[IdrEmployee] bigint not null, 
		[idparent_id] bigint null,

		-- дополнительные поля которые заполняются по данным из асета ПК Windows
		[Custom1] nvarchar(255) null,
		[Custom2] nvarchar(255) null,
		[Custom3] nvarchar(255) null,
		[Custom4] nvarchar(255) null,
		[Custom19] nvarchar(255) null
	);
end;

--alter table dbo.rEmployeeMod add [Custom1] nvarchar(255) null;
--alter table dbo.rEmployeeMod add [Custom2] nvarchar(255) null;
--alter table dbo.rEmployeeMod add [Custom3] nvarchar(255) null;
--alter table dbo.rEmployeeMod add [Custom4] nvarchar(255) null;
--alter table dbo.rEmployeeMod add [Custom19] nvarchar(255) null;

