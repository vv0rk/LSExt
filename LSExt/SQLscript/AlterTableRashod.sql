
use lansweeperdb;

go

-- 
--alter table dbo.rMaterialOriginal
--drop constraint FK_rManufacturer_rMaterialOriginal_IdManufacturer

--alter table dbo.rMaterialOriginal
--add constraint FK_rManufacturer_rMaterialOriginal_IdManufacturer Foreign Key (IdManufacturer) References rManufacturer (Id) on Delete Cascade

drop trigger dbo.Trigger_rMaterialRashod_Insert

GO

/****** Object:  Trigger [dbo].[Trigger_Create]    Script Date: 17.12.2016  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create trigger trigger_rmaterialrashod_insert
on [dbo].[rmaterialrashod] for insert
as
begin
	-- set nocount on added to prevent extra result sets from
	-- interfering with select statements.
	set nocount on;

	Declare @Msg varchar(8000)
	set @Msg = N'Ошибка при назначении материала на устройство. Проверить комплект'

	-- проверяем правильность назначения материала на устройство
		if not exists (select 
			mr.id
		from inserted as mr
		inner join dbo.rmateriallink as ml on mr.idmaterialanalog = ml.idanalog
		inner join dbo.rmodelcomplect as mc on ml.idoriginal = mc.idmaterialoriginal
		inner join dbo.rmodeldevice as md on mc.idmodel = md.id
		inner join dbo.tblassetcustom as ac on mr.assetid = ac.assetid

		where md.model = ac.model
		)
		begin 
			raiserror(50005,10,1,@Msg)
			rollback transaction
		end



	insert into 
		[dbo].rsetrmhist
		(
			assetid,
			custom1,
			custom2,
			custom3,
			custom4,
			custom5,
			[date],
			idmaterialanalog
		)
		select
			i.assetid,
			ac.custom1,
			ac.custom2,
			ac.custom3,
			ac.custom4,
			ac.custom5,
			i.date,
			i.idmaterialanalog
		from inserted as i
		inner join dbo.tblassetcustom as ac on i.assetid = ac.assetid

	insert into 
		[dbo].rsetprinthist
		(
			assetid,
			company,
			city,
			[address],
			officenr,
			placenr,
			datecheck,
			printedpages
		)
		select
			i.assetid,
			ac.custom1,
			ac.custom2,
			ac.custom3,
			ac.custom4,
			ac.custom5,
			i.date,
			i.printedpages
		from inserted as i
		inner join dbo.tblassetcustom as ac on i.assetid = ac.assetid

end

go
