
use lansweeperdb;

go

/*
	записи в эту таблицу должны добавляться раз в сутки
	для этого надо скрипт разработать и запустить по расписанию
*/

if object_id (N'rPrintHist') is null
begin;
	Create table dbo.rPrintHist (
		Id int not null identity(1,1) primary key,
		AssetId int not Null,
		Company nvarchar(255) null,
		City nvarchar(255) null,
		Address nvarchar(255) null,
		Officenr nvarchar(255) null,
		Placenr nvarchar(255) null,
		datecheck datetime null,
		printedpages numeric(18,0) null,
		IdMaterialRashod int null,
		Constraint FK_rPrintHist_rRashodMaterial_IdMaterialRashod foreign key (IdMaterialRashod)
			references rMaterialRashod(Id),
		IdAssetTransfer int null,
		Constraint FK_rPrintHist_rAssetTransfer_IdAssetTransfer foreign key (IdAssetTransfer)
			references rAssetTransfer (Id) on Delete Cascade
	)
end;

Alter table rPrintHist add IdAssetTransfer int null;
Alter table rPrintHist add Constraint FK_rPrintHist_rAssetTransfer_IdAssetTransfer foreign key (IdAssetTransfer)
			references rAssetTransfer (Id) on Delete Cascade;


go 


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,01/11/2016,>
-- Description:	<Description,Контролирует изменение поля Custom16 и пишет изменения в таблицу rPrintHist для 
-- дальнейшего накопления и использования статистики опечатков принтеров,>
-- =============================================
ALTER TRIGGER [dbo].[tblAssetCustom_Trigger_Update1]
on [dbo].[tblAssetCustom] after UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @dt datetime

	set @dt = (select i.custom15 from inserted as i)

	IF @dt >= GetDate() or @dt < '2016-10-01'
		BEGIN
			set @dt = GetDate()
		END
		
		
    -- Insert statements for trigger here
	Insert Into dbo.rPrintHist(AssetID, Company, City, Address, Officenr, 
	placenr, datecheck, printedpages)
	select d.AssetID,
	d.Custom1, d.Custom2, d.Custom3, d.Custom4, d.Custom5, 
	@dt, i.Custom16
	from inserted as i
	inner join deleted as d on i.AssetID = d.AssetID
	inner join dbo.tblAssets as a on i.AssetID = a.AssetID
	inner join dbo.tsysAssetTypes as at on a.Assettype = at.AssetType
	where d.Custom16 != i.Custom16 and at.AssetTypename = 'Printer'
END

