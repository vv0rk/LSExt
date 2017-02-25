
use lansweeperdb;

go

-- категория для 1С справочника
if OBJECT_ID (N'r1CCategory') is null
	begin;
		Create table r1CCategory
		(	
			[Id] int not null primary key,
			[Name] nvarchar(50) not null,
			Constraint AK_r1CCategory_Name unique(Name)
		)

		insert into dbo.r1CCategory(Id,Name) values (1,N'Категория1');
		insert into dbo.r1CCategory(Id,Name) values (2,N'Категория2');
		insert into dbo.r1CCategory(Id,Name) values (3,N'Категория3');
		insert into dbo.r1CCategory(Id,Name) values (4,N'Категория4');
	end;

