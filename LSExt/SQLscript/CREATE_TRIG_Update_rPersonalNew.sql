USE [lansweeperdb]
GO

/****** Object:  Trigger [dbo].[Trigger_Update1]    Script Date: 1.11.2016 14:44:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,01/11/2016,>
-- Description:	<Когда добавляем Id пользователя в штатное расписание, добавляем Id штатного расписания в rPersonalNew>
-- =============================================
CREATE TRIGGER Trigger_rPersonalNew_Update1
on [dbo].[rShtatR] FOR UPDATE
AS
IF EXISTS ( SELECT *
			FROM dbo.rShtatR as R
			inner join inserted as i on i.idrPersonal = r.idrPersonal
			where r.id != i.id
			)
	BEGIN
		RAISERROR (N'Сотрудник не может занимать две и более должности одновременно',10,1)
	ROLLBACK TRANSACTION
	END
else 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	with c as (
		select 
			i.id as src_Id,
			p.idrShtatR as tgt_Id
		from inserted as i 
		inner join dbo.rPersonalNew as p on i.idrPersonal = p.Id
		) update c set
		tgt_id = src_Id;

END

GO
