use lansweeperdb;

go

/*
	Тип хранилища определяется типом (idType): 
		Личной карточкой 
		Оперативным складом, 
		Основным складом ...
*/

if object_id (N'rDvigLKType') is null
begin;
	CREATE TABLE [dbo].rDvigLKType
	(
		[Id] INT NOT NULL PRIMARY KEY,	
		[TypeName] nvarchar(255) null,
		Constraint AK_rDvigLKType_TypeName UNIQUE (TypeName)
	);
end;

insert into rDvigLKType(id, TypeName) VALUES( 1, N'Личная карточка');
insert into rDvigLKType(id, TypeName) VALUES( 2, N'Оперативный склад');
insert into rDvigLKType(id, TypeName) VALUES( 3, N'Основной склад');
