use lansweeperdb;

go

/*
	в записях учитывается движение ТМЦ
*/

if object_id (N'rDvigControl') is null
begin;
	CREATE TABLE [dbo].rDvigControl
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- AssetId идентификатор устройства которое двигается
		[AssetId] int not null,
		Constraint FK_rDvigControl_tblAssets_AssetId_AssetId foreign key (AssetId)
			references dbo.tblAssets (AssetId),

		-- при движении надо сделать ограничение источник или цель может быть только склад или пользователь
		-- для включения этого ограничения надо сделть тригер

		-- rEmployee из наумена, ключевой столбец Bigint в Access работать не будет 
		-- rEmployeeMod это копия для работы в Access этого достаточно так как 26000 сотрудников 
		-- int в tsql поддерживает до 2 147 483 647 (4 байта)
		-- для регулярного обновления информации необходимо сделать скрипт sql
		[idSourcePers] int null,
		Constraint FK_rDvigControl_rEmployeeMod_idSourcePers_id foreign key (IdSourcePers)
			references dbo.rEmployeeMod(id),
		[idTargetPers] int null,
		Constraint FK_rDvigControl_rEmployeeMod_idTargetPers_id foreign key (idTargetPers)
			references dbo.rEmployeeMod(id),

		-- ТМЦ можно передвигать не на пользователя а на склад
		-- создаем перечень складов rSclad
		[idSourceSclad] int null,
		Constraint FK_rDvigControl_rSclad_idSourceSclad_id foreign key (idSourceSclad)
			references dbo.rSclad(id),
		[idTargetSclad] int null,
		Constraint FK_rDvigControl_rSclad_idTargetSclad_id foreign key (idTargetSclad)
			references dbo.rSclad(id),

		-- для полноты информации вводим адреса источника и цели
		[CitySource] nvarchar(100) null,
		[CityTarget] nvarchar(100) null,

		[AddressSource] nvarchar(255) null,
		[AssressTarget] nvarchar(255) null,

		-- инициатор формирования перемещения
		-- заполняется автоматически из триггера
		[Initiator] nvarchar(150) not null,
		-- этот инициатор который указывается им самим (в идеале должен совпасть с Initiator
		[idInitiator] int not null,
		Constraint FK_rDvigControl_rEmployeeMod_idInitiator_id foreign key (idInitiator)
			references dbo.rEmployeeMod(id),
		
		-- утверждение перемещения
		[IsApproved] bit default 0,
		-- заполняется автоматически из триггера при утверждении
		[Approved] nvarchar(150) not null,
		-- этот инициатор который указывается им самим (в идеале должен совпасть с idApproved
		[idApproved] int not null,
		Constraint FK_rDvigControl_rEmployeeMod_idApproved_id foreign key (idApproved)
			references dbo.rEmployeeMod(id),

	);
end;
