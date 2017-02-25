
use lansweeperdb;

go

-- ��������� ��� 1� �����������
if OBJECT_ID (N'r1CCategory') is null
	begin;
		Create table r1CCategory
		(	
			[Id] int not null primary key,
			[Name] nvarchar(50) not null,
			Constraint AK_r1CCategory_Name unique(Name)
		)

		insert into dbo.r1CCategory(Id,Name) values (1,N'���������1');
		insert into dbo.r1CCategory(Id,Name) values (2,N'���������2');
		insert into dbo.r1CCategory(Id,Name) values (3,N'���������3');
		insert into dbo.r1CCategory(Id,Name) values (4,N'���������4');
	end;

