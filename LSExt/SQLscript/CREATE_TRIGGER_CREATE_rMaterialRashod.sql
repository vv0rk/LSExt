USE [lansweeperdb]
GO

/****** Object:  Trigger [dbo].[Trigger_Create]    Script Date: 17.12.2016  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- НЕ ЗАКОНЧЕНО
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,17/12/2016,>
-- Description:	<Когда вставляем новую запись, проверяем что материал есть аналог оригинального материала, который назначен на 
-- устройство >
-- =============================================
CREATE TRIGGER Trigger_rMaterailRashod_insert
on [dbo].[rMaterialRashod] FOR INSERT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @part NVARCHAR(100)
	DECLARE @model nvarchar(255)

	set @part = (select PartNumber from inserted)

	set @model = (
					select 
						ac.Model
					from inserted as i
					inner join [dbo].tblAssetCustom as ac on i.AssetId = ac.AssetId
				)
			
	select 

END

GO
