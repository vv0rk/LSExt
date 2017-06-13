use lansweeperdb;

go

/*
	Таблица с рекомендациями по замене CPU
*/

if object_id (N'rCPUcat') is null
begin;
	CREATE TABLE [dbo].rCPUcat
	(
		[Id] INT NOT NULL PRIMARY KEY,	
		
		-- Категория рекомендации
		[Category] nvarchar(255) not null
	);
end;

insert into rCPUcat (id, Category) values (0, N'');
insert into rCPUcat (id, Category) values (1, N'замена 1 очередь');
insert into rCPUcat (id, Category) values (2, N'замена 2 очередь');

if object_id (N'rCPUrek') is null
begin;
	CREATE TABLE [dbo].rCPUrek
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,	
		
		-- модель CPU 
		[CPU] nvarchar(255) not null,
		-- категория рекомендация
		[idCategory] int not null default 0,
		Constraint FK_rCPUrek_rCPUcat_idCategory_id foreign key (idCategory)
			references rCPUcat (id)
	);
end;

