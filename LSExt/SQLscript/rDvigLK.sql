use lansweeperdb;

go

/*
	Это не только личная карточка это объект хранилище
	На этом объекту назначен ответственный.
	Привязка объекта ИТ к объекту хранения производится только при наличии подтверждающего документа.
	Тип хранилища определяется типом (idType): Может быть Личной карточкой, Оперативным складом, Основным складом ...
	Для каждого хранилища требуется свой формат подтверждающего документа и только в этом заключается разница между алгоритмами перемещен.
	Личная карточка это документ, который подтверждает 
	личная карточка имеет силу, только тогда, когда ее одобрил МОЛ
*/

if object_id (N'rDvigLK') is null
begin;
	CREATE TABLE [dbo].rDvigLK
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,	
		
		-- тип хранилища: личная карточка, центральный склад, оперативный склад
		[idType] int not null,
		Constraint FK_rDvigLK_rDvigLKType_idType_Id foreign key (idType)
			references dbo.rDvigLKType (Id),
		-- ответственный за это хранилище, идентификатор пользователя из rEmployee
		[idResponce] bigint not null,
		Constraint FK_rDvigLK_rEmployee_idResponce_Id foreign key (idResponce)
			references dbo.rEmployee (id),

		-- Организация которой принадлежит данное хранилище
		[idCompany] int not null,
		Constraint FK_rDvigLK_rCompany_idCompany_id foreign key (idCompany)
			references dbo.rCompany$ (id),

		[Gorod] nvarchar(255) null,
		[Adress] nvarchar(255) null,
		[Office] nvarchar(255) null
		
	);
end;

