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

-- drop trigger Trigger_rMaterialOriginalUpdate 


CREATE TRIGGER Trigger_rMaterialOriginalUpdate on rMaterialOriginal after update
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	with C as (
	select 
		mo.PartNumber as PartNumber_tgt
		, mo.Name as Name_tgt
		, mo.Resource as Resource_tgt
		, mo.IdManufacturer as IdManufacturer_tgt
		, i.PartNumber as PartNumber_src
		, i.Name as Name_src
		, i.Resource as Resource_src
		, i.IdManufacturer as IdManufacturer_src
	from deleted as d
	inner join dbo.rMaterialAnalog as mo on (d.PartNumber = mo.PartNumber and d.IdManufacturer = mo.IdManufacturer)
	inner join inserted as i on d.id = i.Id
	)
	update c set
	PartNumber_tgt = PartNumber_src
	, Name_tgt = Name_src
	, Resource_tgt = Resource_src
	, IdManufacturer_tgt = IdManufacturer_src;

			

END

GO
