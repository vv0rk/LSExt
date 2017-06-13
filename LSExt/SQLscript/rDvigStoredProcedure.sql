use lansweeperdb;

go

/*
	хранимые процедуры по которым производится движение оборудования по ЛК
*/

/*
	возвращает элементы записи rDvigLKspec 
*/
alter function fn_DvigLKgetSpec ( @idLk int = NULL )
	returns table 
	as return (
		select 
			d.Id
			, n.code
			, ak.name
			, e.title
			, ai.AssetId
			, ai.inventoryNumber
			, ai.serialNumber
			, c.parent

		from rDvigLK as d
		inner join rDvigLKspec as ds on d.Id = ds.idLK
		inner join rAssetsImported as ai on ds.AssetId = ai.id
		inner join rAssetsKsu as ak on ai.assetKsuId = ak.id
		inner join rNomenclature as n on ak.nomenclatureId = n.id
		left join rCompany$ as c on d.idCompany = c.Id
		inner join rEmployee as e on d.idResponce = e.id
		left join tblAssets as a on ai.assetId = a.AssetID
		where d.Id = @idLK
	)

GO


/*
	функция возвращает перечень ассетов для выдачи 
	принимает на входе организацию а выдает 
*/
alter function fn_DvigLKgetAssets ( @org nvarchar(255) = NULL )
	returns table 
	as return (
		select 
			ai.id
			, n.code as nomCode
			, n.name
			, ai.inventoryNumber
			, ai.serialNumber
			, ai.assetId
			, c.Code as company

		from rAssetsImported as ai 
		inner join rAssetsKsu as ak on ai.assetKsuId = ak.id
		inner join rNomenclature as n on ak.nomenclatureId = n.id
		inner join rCompany$ as c on ak.companyId = c.id
		left join tblAssets as a on ai.assetId = a.AssetID
		where c.Code = @org
	)
GO

/*
	функция для внесения данных о перемещении в Log
*/
Alter procedure sp_DvigLKcreateLog (	@AssetId int = NULL, 
										@idLKsrc int = NULL, 
										@idLKtgt int = NULL, 
										@username nvarchar(255) = NULL,
										@datecreate datetime = NULL
									)
AS
	BEGIN
		SELECT @username = SYSTEM_USER, @datecreate = GETDATE()

		IF @idLKsrc is null or @idLKtgt is null or @AssetId is null 
			BEGIN
				PRINT N'Источник, цель и ассет id не могут быть NULL';
				return 1;
			END

		INSERT INTO dbo.rDvigLKspecLog ( AssetId, idLKsrc, idLKtgt, idStatus, username, datecreate)
		VALUES (@AssetId, @idLKsrc, @idLKtgt, 1, @username, @datecreate)

		return 0;
	END;
GO





/* процедура для формирования перемещения оборудования 
	АЛГОРИТМ РАБОТЫ
	оборудование не может одновременно прийти со склада и ЛК
	оборудование не может одновременно быть списано на склад и ЛК

	оборудование которое участвует в незавершенной транзакции, 
	не может участвовать в другой транзакции.

	AssetId - идентификатор устройства, который перемещается

	idLKsrc - идентификатор ЛК с которой списывается оборудование
	idLKtgt - идентификатор ЛК на которую оборудование приходуется

	idScladSrc - идентификатор склада с которого списывается оборудование
	idScladTgt - идентификатор слкада на который оборудование приходит
*/
--create procedure sp_DvigLKtoLK
--	@AssetId int = NULL,
--	@idLksrc int = NULL,
--	@idLKtgt int = NULL,
--	@idScladsrc int = NULL,
--	@idScladtgt int = NULL

--AS
--	Set nocount on;

--	-- проверяем что одновременно не назначены источники склад и ЛК
--	IF (@idLKsrc is not null and @idScladsrc is not null) or (@idLKtgt is not null and @idScladtgt is not null) 
--		BEGIN
--			PRINT N'Одновременно не может быть источником/приемником склад и ЛК'
--			RETURN (1)
--		END

--	-- проверяем что оборудование не участвует в незавершенных транзакциях
--	IF EXISTS (
--		Select *
--		from dbo.rDvigLKspecLog as dlsl
--		where dlsl.AssetId = @AssetId and dlsl.isApproved = 0 )
--		BEGIN
--			PRINT N'Этот асет участвует в незавершенной транзации...';
--			PRINT N'Завершите или отклоните предыдущую транзакцию...';
--			RETURN (1)
--		END

--	-- вставляем запись в журнал
--	insert into dbo.rDvigLKspecLog (AssetId, idLKsrc, idLKtgt)
--	VALUES (@AssetID, @LKsrc, @LKtgt)
			
--	-- удаляем запись об устройстве из предыдущей ЛК
--	delete from dbo.rDvigLKspec 
--	Where dbo.rDvigLKspec.AssetId = @AssetID 

--	-- вставляем запись в спецификацию для приемника ЛК
--	insert into dbo.rDvigLKspec (AssetId, idLK)
--	VALUES (@AssetID, @LKtgt);
--GO