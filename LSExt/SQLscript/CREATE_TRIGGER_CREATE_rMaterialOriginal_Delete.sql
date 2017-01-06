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
CREATE TRIGGER TRIGGER_rMaterialOriginal_Delete
on [dbo].[rMaterialOriginal] FOR DELETE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @id int
	declare @partnumber nvarchar(100)

	select @id = (select id from deleted)
	select @partnumber = (select PartNumber from deleted)

	delete from [dbo].rMaterialLink
	where [dbo].rMaterialLink.IdOriginal = @id

	--delete from [dbo].rMaterialAnalog
	--where [dbo].rMaterialAnalog.PartNumber = @partnumber


END

GO
