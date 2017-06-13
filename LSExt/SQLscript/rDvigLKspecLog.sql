use lansweeperdb;

go

/*
	журнал транзакций движения оборудования

	Одна транзакция представляет собой перемещение оборудования с одного хранилища в другое
	транзакция начинается когда формируется перемещение ассета из одного хранилища в другое
	транзакция заканчивается когда мол подтверждает ее (для этого мол должен получить подписанный 
	документ подтверждающий перемещение, проверить его и поместить на дальнейшее хранение)

	В случае когда транзакция не подтверждена, она должна быть откачена назад до последнего подтвежденного 
	состояния. Состояние хранилищ восстанавливается. Документы возвращаются молу и помещаются на 
	дальнейшее хранение.

	Когда формируется запись для перемещения в эту таблицу заносятся данные о транзакции

*/

if object_id (N'rDvigLKspecLog') is null
begin;
	CREATE TABLE [dbo].rDvigLKspecLog
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		

		-- ссылка на запись которая формировалась из бухгалтерского учета.
		[AssetId] int not null,
		Constraint FK_rAssets_rDvigLKspecLog_AssetId_id foreign key (AssetId)
			references dbo.rAssetsImported (id),

		-- ОГРАНИЧЕНИЕ. ИСТОЧНИК НЕ МОЖЕТ БЫТЬ ОДНОВРЕМЕННО СКЛАД И ЛК
		-- ссылка на хранилище с которой перемещается asset
		[idLKsrc] int null,
		Constraint FK_rDvigLKspecLog_rDvigLK_idLKsrc_id foreign key (idLKsrc)
			references dbo.rDvigLK (id),

		-- ссылка на хранилище на которое перемещается asset
		[idLKtgt] int null,
		Constraint FK_rDvigLKspecLog_rDvigLK_idLKtgt_id foreign key (idLKtgt)
			references dbo.rDvigLK (id),

		[idStatus] int not null default 1,
		Constraint FK_rDvigLKspecLog_rDvigLKStatus_idStatus_id foreign key (idStatus)
			references dbo.rDvigLKStatus (id),

		-- информация о времени создания записи перемещения и о пользователе создавшем запись
		[username] nvarchar(255) null,
		[datecreate] datetime null,

		-- информация о пользователе подтвердившем завершение транзаци		
		[userapprove] nvarchar(255) null,
		[dateapprove] datetime null,
		[isApproved] bit not null default 0
	);
end;
