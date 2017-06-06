use lansweeperdb;

go

/*
	хранимые процедуры по которым производится движение оборудования по ЛК
*/

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
create procedure sp_DvigLKtoLK
	@AssetId int = NULL,
	@idLksrc int = NULL,
	@idLKtgt int = NULL,
	@idScladsrc int = NULL,
	@idScladtgt int = NULL

AS
	Set nocount on;

	-- проверяем что одновременно не назначены источники склад и ЛК
	IF (@idLKsrc is not null and @idScladsrc is not null) or (@idLKtgt is not null and @idScladtgt is not null) 
		BEGIN
			PRINT N'Одновременно не может быть источником/приемником склад и ЛК'
			RETURN (1)
		END

	-- проверяем что оборудование не участвует в незавершенных транзакциях
	IF EXISTS (
		Select *
		from dbo.rDvigLKspecLog as dlsl
		where dlsl.AssetId = @AssetId and dlsl.isApproved = 0 )
		BEGIN
			PRINT N'Этот асет участвует в незавершенной транзации...';
			PRINT N'Завершите или отклоните предыдущую транзакцию...';
			RETURN (1)
		END

	-- вставляем запись в журнал
	insert into dbo.rDvigLKspecLog (AssetId, idLKsrc, idLKtgt)
	VALUES (@AssetID, @LKsrc, @LKtgt)
			
	-- удаляем запись об устройстве из предыдущей ЛК
	delete from dbo.rDvigLKspec 
	Where dbo.rDvigLKspec.AssetId = @AssetID 

	-- вставляем запись в спецификацию для приемника ЛК
	insert into dbo.rDvigLKspec (AssetId, idLK)
	VALUES (@AssetID, @LKtgt);
GO