use lansweeperdb;

go

/*
	журнал движения оборудования
*/

if object_id (N'rDvigLKspecLog') is null
begin;
	CREATE TABLE [dbo].rDvigLKspecLog
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		

		-- ссылка на Asset который перемещается
		[AssetId] int not null,
		Constraint FK_rDvigLKspec_tblAssets_assetid_assetid foreign key (assetid)
			references dbo.tblAssets (Assetid),

		-- ОГРАНИЧЕНИЕ. ИСТОЧНИК НЕ МОЖЕТ БЫТЬ ОДНОВРЕМЕННО СКЛАД И ЛК
		-- ссылка на личную карточку с которой перемещается asset
		[idLKsrc] int null,
		Constraint FK_rDvigLKspecLog_rDvigLK_idLKsrc_id foreign key (idLKsrc)
			references dbo.rDvigLK (id),
		-- ссылка на личную карточку на которую перемещается asset
		[idLKtgt] int null,
		Constraint FK_rDvigLKspecLog_rDvigLK_idLKtgt_id foreign key (idLKtgt)
			references dbo.rDvigLK (id),

		-- ОГРАНИЧЕНИЕ. ПРИЕМНИК НЕ МОЖЕТ БЫТЬ ОДНОВРЕМЕННО СКЛАД И ЛК
		-- ссылка на склад с которого перемещается asset
		[idScladsrc] int null,
		Constraint FK_rDvigLKspecLog_rSclad_idScladsrc_id foreign key (idScladsrc)
			references dbo.rSclad (id),
		-- ссылка на склад на который перемещается asset
		[idScladtgt] int null,
		Constraint FK_rDvigLKspecLog_rSclad_idScladtgt_id foreign key (idScladtgt)
			references dbo.rSclad (id),

		-- информация о времени создания записи перемещения и о пользователе создавшем запись
		[username] nvarchar(255) null,
		[datecreate] datetime null,

		-- информация о пользователе подтвердившем завершение транзаци		
		[userapprove] nvarchar(255) null,
		[dateapprove] datetime null,
		[isApproved] bit not null default 0



	);
end;
