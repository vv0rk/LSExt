
use lansweeperdb;

go

-- rActiveCategory1 
/*
	Ёто активы из категории 1 они должны учитыватьс€ по одному объекту 
	Ёти активы формируютс€ из ѕрихода
	ѕосле того как активы сформированы, эту позицию прихода нельз€ изменить до тех пор,
	пока количество единиц прихода не будет равно количеству ≈диниц из этого прихода.
	”даление и обновление таблиц rPrihodSpec и rActiveCategory1 контролируетс€ триггерами
*/
if OBJECT_ID (N'rActiveCategory1') is null
	begin;
		Create table rActiveCategory1
		(
			[Id] int not null identity(1,1) primary key,
			[IdPrihodSpec] int not null, -- запись спецификации из которой была сформирована эта запись
			Constraint FK_rActiveCategory1_rPrihodSpec_IdPrihodSpec_Id foreign key (IdPrihodSpec)
				references rPrihodSpec (Id),
			[AssetId] int null,
			Constraint FK_rActiveCategory1_rAsset_AssetId_AssetId foreign key (AssetId)
				references rAsset (AssetId),
			[nrSerial] nvarchar(50) null,
			[nrInv] nvarchar(50) null,
			[nrNom] nvarchar(50) null,
			[Number] int not null default 1
		)
	end;

go


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,24/02/2017,>
-- Description:	<контролируем удаление, изменение, вставка>
/*
	ѕровер€ем что не такого AssetId не назначено дл€ другого 
*/
-- =============================================
CREATE TRIGGER Trigger_rActiveCategory1_delete
on [dbo].[rActiveCategory1] FOR insert, update
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
				select *
				from inserted as ii
				inner join dbo.rActiveCategory1 as ac on ii.AssetId = ac.AssetId
				where ii.Id <> ac.Id
			)
		BEGIN
			RAISERROR (N'“акой јссет уже св€зан с другим јктивом rActiveCategory1 и запрещен дл€ повторного назначени€',10,1)
			ROLLBACK TRANSACTION
		END

	IF EXISTS (
				select *
				from inserted as ii
				inner join dbo.rActiveCategory1 as ac on ii.nrSerial = ac.nrSerial
				where ii.Id <> ac.Id and ii.nrSerial is not null
			)
		BEGIN
			RAISERROR (N'“акой јссет уже св€зан с другим јктивом rActiveCategory1 и запрещен дл€ повторного назначени€',10,1)
			ROLLBACK TRANSACTION
		END


END



-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,24/02/2017,>
-- Description:	<контролируем удаление, изменение, вставка>
/*
	если количество по приходу меньше чем суммарное то разрешена вставка
	если количество равно то нельз€ никаких действий
	если количество по приходу меньше то разрешено удаление
	UPDATE запрещено, если мен€етс€ количество или IdPrihodSpec
*/
-- =============================================
--CREATE TRIGGER Trigger_rActiveCategory1_delete
--on [dbo].[rActiveCategory1] FOR delete
--AS
--BEGIN
--	SET NOCOUNT ON;
--	declare @id_prihod int;
--	select @id_prihod = (select IdPrihodSpec from deleted);
	
--	declare @num_prihod int;
--	select @num_prihod = (select number from dbo.rPrihodSpec where dbo.rPrihodSpec.Id = @id_prihod);

--	declare @nr_after_delete int;
--	select @nr_after_delete = (
--				select sum(number)
--				from dbo.rActiveCategory1 
--				where dbo.rActiveCategory1.IdPrihodSpec = @id_prihod
--				group dbo.rActiveCategory1.IdPrihodSpec
--				);

--	IF @num_prihod >
--END

