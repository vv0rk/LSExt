
use lansweeperdb;

go

/*
	Перемещение устройства с места на место и замена одного устройства на другое
	это необходимо для планирования расходников для другого устройства
*/

if object_id (N'rAssetTransferStatus') is null
begin;
	Create table dbo.rAssetTransferStatus (
		Id int not null Identity (1,1) primary key,
		Statud nvarchar(10) not null
	)
end;


if object_id (N'rAssetTransfer') is null
begin;
	Create table dbo.rAssetTransfer (
		Id int not null Identity (1,1) primary key,
		CreateDate DateTime not null default Current_TIMESTAMP,
		Comment nvarchar(200) null,
		IdStatus int not null,
		Constraint FK_rAssetTransfer_rAssetTransferStatus_IdStatus_Id foreign key (IdStatus)
			references rAssetTransferStatus (Id)
	)
end;

/*
	Specification of Transfer
*/
if object_id (N'rAssetTransferSpec') is null
begin;
	Create table dbo.rAssetTransferSpec (
		Id int not null Identity (1,1) primary key,
		IdAssetSource int not null,
		Constraint FK_rAssetTransferSpec_rAsset_IdAssetSource_AssetId foreign key (IdAssetSource)
			references rAsset(AssetID),
		IdAssetTarget int not null,
		Constraint FK_rAssetTransferSpec_rAsset_IdAssetTarget_AssetId foreign key (IdAssetTarget)
			references rAsset(AssetID),
		IdAssetTransfer int not null 
		Constraint FK_rAssetTransferSpec_rAssetTransfer_IdAssetTransfer_Id foreign key (IdAssetTransfer)
			references rAssetTransfer(Id) on Delete Cascade
	)
end;

/*
	Триггер при сохранении 
	1. Удаляет из rPrintHist все записи относящиеся к этому rAssetTransfer
	2. Вычисляет количество AssetTargets n
	3. Создает для каждого вновь назначенного AssetSource запись в rPrintHist 
	с количеством отпечатанных страниц = printedPages / n
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER Trigger_rAssetTransferSpecInsert on rAssetTransferSpec after insert, update
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @AssetIdSource int
	declare @number int
	declare @transferId int
	declare @assetid int
	
	set @AssetIdSource = (select ats.IdAssetSource from dbo.rAssetTransferSpec as ats	group by ats.IdAssetSource, ats.IdAssetTransfer)
	set @number = (select count(ats.Id) from dbo.rAssetTransferSpec as ats	group by ats.IdAssetSource, ats.IdAssetTransfer)
	set @transferId = (select inserted.IdAssetTransfer from inserted)
	set @assetid = (select inserted.IdAssetTarget from inserted)

	delete from dbo.rPrintHist where dbo.rPrintHist.IdAssetTransfer = @transferId

	insert into dbo.rPrintHist (
		AssetId
		, Company
		, City
		, Address
		, Officenr
		, Placenr
		, datecheck
		, printedpages
		, IdAssetTransfer
	)
	select 
		ats.IdAssetTarget as AssetId
		, p.Company as Company
		, p.City as City
		, p.Address as Address
		, p.Officenr as Officenr
		, p.Placenr as Placenr
		, p.datecheck as datecheck
		, (p.printedpages / @number) as printedpages
		, ats.IdAssetTransfer as IdAssetTransfer
	from dbo.rAssetTransfer as t 
	inner join dbo.rAssetTransferSpec as ats on t.Id = @transferId
	inner join dbo.rPrintHist as p on ats.IdAssetSource = p.AssetId


END;

go

CREATE TRIGGER Trigger_rAssetTransferSpecDelete on rAssetTransferSpec after delete
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @IdAssetTransfer int 
	declare @AssetId int

	set @IdAssetTransfer = (select IdAssetTransfer from deleted)
	set @AssetId = (select IdAssetTarget from deleted)

	delete from dbo.rPrintHist where dbo.rPrintHist.IdAssetTransfer = @IdAssetTransfer and dbo.rPrintHist.AssetId = @AssetId
	
END
