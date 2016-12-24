USE [lansweeperdb]
GO

/****** Object:  Trigger [dbo].[Trigger_Create]    Script Date: 17.12.2016  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,17/12/2016,>
-- Description:	<Когда добавляем запись в таблицу rMaterialOriginal такая же запись добавляется в таблицу rMaterialAnalog 
--				и создается запись в таблице rMaterialLink>
-- =============================================
CREATE TRIGGER Trigger_Create
on [dbo].[rMaterialOriginal] FOR INSERT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO 
		[dbo].rMaterialAnalog
		(
			PartNumber,
			Name,
			[Resource],
			IdManufacturer
		)
		Select
			PartNumber,
			Name,
			[Resource],
			IdManufacturer
		From
			INSERTED

	INSERT INTO
		[dbo].rMaterialLink
		(
			IdOriginal,
			IdAnalog
		)
		Select
			i.Id,
			ma.Id
		from inserted as i
		inner join [dbo].rMaterialAnalog as ma on i.PartNumber = ma.PartNumber
			

END

GO
