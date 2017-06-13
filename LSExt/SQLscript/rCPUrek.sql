use lansweeperdb;

go

/*
	������� � �������������� �� ������ CPU
*/

if object_id (N'rCPUcat') is null
begin;
	CREATE TABLE [dbo].rCPUcat
	(
		[Id] INT NOT NULL PRIMARY KEY,	
		
		-- ��������� ������������
		[Category] nvarchar(255) not null
	);
end;

insert into rCPUcat (id, Category) values (0, N'');
insert into rCPUcat (id, Category) values (1, N'������ 1 �������');
insert into rCPUcat (id, Category) values (2, N'������ 2 �������');

if object_id (N'rCPUrek') is null
begin;
	CREATE TABLE [dbo].rCPUrek
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,	
		
		-- ������ CPU 
		[CPU] nvarchar(255) not null,
		-- ��������� ������������
		[idCategory] int not null default 0,
		Constraint FK_rCPUrek_rCPUcat_idCategory_id foreign key (idCategory)
			references rCPUcat (id)
	);
end;

