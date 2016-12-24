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
on [dbo].[rMaterialOriginal] FOR UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	with c as (
		select 
			mo.IdManufacturer as Manuf_src,
			mo.PartNumber as PN_src,
			mo.Name as Name_src,
			mo.Resource as Res_src,

			ma.IdManufacturer as Manuf_tgt,
			ma.PartNumber as PN_tgt,
			ma.Name as Name_tgt,
			ma.Resource as Res_tgt

		from INSERTED as mo
		inner join dbo.rMaterialLink as ml on mo.Id = ml.IdOriginal
		inner join dbo.rMaterialAnalog as ma on ml.IdAnalog = ma.Id			
	)
	update c 
	set 
	Manuf_tgt = Manuf_src,
	PN_tgt = PN_src,
	Name_tgt = Name_src,
	Res_tgt = Res_src;

END

GO
