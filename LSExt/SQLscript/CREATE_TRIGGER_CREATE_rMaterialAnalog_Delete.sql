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
-- Description:	<Перед вставкой новой записи проверяем что комплект для такого расходника и модели существуют>
-- =============================================
CREATE TRIGGER TRIGGER_rMaterialRashod_Insert
on [dbo].[rMaterialAnalog] BEFORE INSERT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @id int

	select @id = (select id from deleted)

	delete from [dbo].rMaterialLink
	where [dbo].rMaterialLink.IdAnalog = @id


END

GO
