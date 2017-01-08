
use lansweeperdb;

go

--drop table dbo.rSetRMHist;
--drop table [dbo].rModelComplect;
--drop table [dbo].rModelDevice;
--DROP TABLE [dbo].rMaterialLink;
--DROP TABLE [dbo].rMaterialRashod;
--DROP TABLE [dbo].rMaterialAnalog;
--DROP TABLE [dbo].rMaterialOriginal;
--drop table dbo.rAsset


--drop table [dbo].r

-- ������� � ������������� ���������� �����������,
-- ������������ ��� ����������� ����������
-- ��� �������� ������ � ������� ����������, ��������� ������ � ������� rMaterialAnalog � rLinkMaterial
CREATE TABLE [dbo].rMaterialOriginal
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	-- ��� ���������� ��������� �� ������������� �������������
	[PartNumber] NVARCHAR(100) NOT NULL,	-- ������� ��� ��� ���� ������ ��������� ������ ���������� ��������
		Constraint AK_rMaterialOriginal_PartNumber UNIQUE(PartNumber),
	-- �������� ���������� ���������
	[Name] NVARCHAR(255) NOT NULL, 
	-- ������ ���������� ��������� (�����������, ���� ���������� ��������������)
	[Resource] INT NULL,

	-- ����� � �������� rManufacturer �� ���� Id
	[IdManufacturer] INT NULL,
		Constraint FK_rManufacturer_rMaterialOriginal_IdManufacturer Foreign Key (IdManufacturer) 
			References rManufacturer (Id) on Delete Cascade
);

-- ������� � ��������� ��������� ����������
-- ��������� ��������� �� ���� ������� ����������� �� ����������
-- ������� ��������� ���������� ������� � ������������� ���������� ����������� ����� �������
-- rLinkMaterials
CREATE TABLE [dbo].rMaterialAnalog
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[IdManufacturer] INT NULL,
	-- ��� ���������� ��������� �� ������������� �������������
	[PartNumber] NVARCHAR(100) NOT NULL,	-- ������� ��� ��� ���� ������ ��������� ������ ���������� ��������
		Constraint AK_rMaterialAnalog_PartNumber UNIQUE(PartNumber),
	-- �������� ���������� ���������
	[Name] NVARCHAR(255) NOT NULL, 
	-- ������ ���������� ��������� (�����������, ���� ���������� ��������������)
	[Resource] INT NULL,

	-- ���� ������� ����� � �������� rManufacturer �� ���� ShortName
	Constraint FK_rManufacturer_rMaterialAnalog_Id FOREIGN KEY (IdManufacturer)
		References rManufacturer (Id)
);

-- ������� ������������� ������������ ���������� � ��������
-- ������������ ��� �������� ���������� ������� ��������� �� ����������
CREATE TABLE [dbo].rMaterialLink
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[IdOriginal]	INT NOT NULL,
	[IdAnalog]		INT NOT NULL,

	--Constraint FK_rMaterialOriginal_rMaterialLink_Id FOREIGN KEY (idOriginal)
	--	References rMaterialOriginal (Id),
	-- ���� ������� ������ � rMaterialAnalog �� ��������� ��� ��������� ������ � ���� �������
	Constraint FK_rMaterialAnalog_rMaterialLink_Id FOREIGN KEY (IdAnalog)
		References rMaterialAnalog (Id)
		on DELETE CASCADE
)

-- ������� ������� ����������� ������ ���������� �� �����������
CREATE TABLE [dbo].rMaterialRashod
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	-- ������������� ���������� �� ������� ������������� ��������� �������� ��� �������������
	[AssetId] INT NOT NULL,
	-- ���� ������� ����� � tblAssetCustom
	Constraint FK_tblAssetCustom_rMaterialRashod_AssetID FOREIGN KEY (AssetId)
		References tblAssetCustom (AssetId),
	-- part number of rashod material whitch installed into device
	[IdMaterialAnalog] INT NOT NULL,
	-- ���� ������� ����� � rRashoMaterial �� ���� �������
	Constraint FK_rMaterialAnalog_rMaterailRashod_IdMaterialAnalog FOREIGN KEY (IdMaterialAnalog)
		References rMaterialAnalog (Id),
	-- ��������������� ���� ��� �������� �����������
	[Id1CSprav] int null,
	Constraint FK_rMaterialRashod_r1CSprav_Id1CSprav foreign key (Id1CSprav)
			References r1CSprav(Id),

	-- ���������� ������������ ������� ��� ����� ���������� ����������� � ������� history
	[PrintedPages] INT, 
	[Date] DATETIME DEFAULT CURRENT_TIMESTAMP

);


-- ������� � �������� ��������� (������ ���� ��������� ������ ���� ��������� � ������������ � ���� ��������)
CREATE TABLE [dbo].rModelDevice
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[Model] NVARCHAR(255) NOT NULL,
		Constraint AK_Model UNIQUE(Model),
	[IdManufacturer] INT,
		Constraint FK_rManufacturer_rModelDevice_IdManufacturer FOREIGN KEY (IdManufacturer)
			References rManufacturer (Id)
);

-- ��������� ���������� �� �����������
-- ��������� ������� ����� ���� ��������� � �����������.
-- ��� ������� ������������ ��� ���������� ������� �� ���������� (������ ����� ���� �������� ������ � ��� ������ ���� �� �������� �������� 
-- ������������� ���������� ��������� ������� ������ � �������� ��� ����� ����������)
CREATE TABLE [dbo].rModelComplect
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
	[IdModel] INT NOT NULL,
		Constraint FK_rModelDevice_rModelComplect_Id FOREIGN KEY (IdModel)
			References rModelDevice (Id),
	[IdMaterialOriginal] INT NOT NULL,
		Constraint FK_rMaterialOriginal_rModelComplect_Id FOREIGN KEY (IdMaterialOriginal)
			References rMaterialOriginal (Id)
);


-- ������� asset-�� ������ ����������� ����� ������� tblAssetCustom
CREATE TABLE [dbo].rAsset
(
	[AssetId] INT NOT NULL PRIMARY KEY,		
	[AssetName] nvarchar(200) not null,
	[Model] nvarchar(200) NULL,
	[AssetTypeName] nvarchar(100) not null,
	[Custom1] nvarchar(255) null,
	[Custom2] nvarchar(255) null,
	[Custom3] nvarchar(255) null,
	[Custom4] nvarchar(255) null,
	[Custom5] nvarchar(255) null,
	[Custom6] nvarchar(255) null,
	[Custom7] nvarchar(255) null,
	[Custom8] nvarchar(255) null,
	[Custom9] nvarchar(255) null,
	[Custom10] nvarchar(255) null,
	[Custom11] nvarchar(255) null,
	[Custom12] nvarchar(255) null,
	[Custom13] nvarchar(255) null,
	[Custom14] nvarchar(255) null,
	[Custom15] nvarchar(255) null,
	[Custom16] nvarchar(255) null,
	[Custom17] nvarchar(255) null,
	[Custom18] nvarchar(255) null,
	[Custom19] nvarchar(255) null,
	[Custom20] nvarchar(255) null,
);


-- ������� ������� ������� ������������� ��������� ���������� � �������������
-- ����������� ������������� ��� �������� ������ � ������� rMaterialRashod
CREATE TABLE [dbo].rSetRMHist
(
	[Id] INT Not null identity(1,1) primary key,
	[AssetId] INT NOT NULL,		
	[Custom1] nvarchar(255) null,
	[Custom2] nvarchar(255) null,
	[Custom3] nvarchar(255) null,
	[Custom4] nvarchar(255) null,
	[Custom5] nvarchar(255) null,
	[Date]		DateTime DEFAULT CURRENT_TIMESTAMP,
	[User]	nvarchar(100) null,
	[IdMaterialAnalog] INT not null,
		Constraint FK_rSetRMHist_rMaterialAnalog foreign key (IdMaterialAnalog)
			references rMaterialAnalog (Id)

);

-- ������������� ������ ������������ � ������ �� �����������
CREATE TABLE [dbo].rModelLink
(
	[Id] INT Not null identity(1,1) primary key,
	-- ����������� �� AssetCustom.Model � distinct
	ModelAsset nvarchar(255) null,		
		Constraint AK_ModelAsset Unique(ModelAsset),
	-- ����������� �� rModelDevice � ����� ������� � AssetCustom9
	ModelSprav nvarchar(255) null,
		Constraint FK_rModelLink_rModelDevice_Model foreign key (ModelSprav)
			references rModelDevice(Model)
			on update Cascade
);


-- ###################### TRIGGERS
/****** Object:  Trigger [dbo].[Trigger_Create]    Script Date: 17.12.2016  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,17/12/2016,>
-- Description:	<����� ��������� ������ � ������� rMaterialRashod ����������� ������ � ������� rSetRMHist>
-- =============================================
create trigger trigger_rmaterialrashod_insert
on [dbo].[rmaterialrashod] for insert
as
begin
	-- set nocount on added to prevent extra result sets from
	-- interfering with select statements.
	set nocount on;

	Declare @Msg varchar(8000)
	set @Msg = N'������ ��� ���������� ��������� �� ����������. ��������� ��������'

	-- ��������� ������������ ���������� ��������� �� ����������
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

GO

-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,17/12/2016,>
-- Description:	<����� ��������� ������ � ������� rMaterialOriginal ����� �� ������ ����������� � ������� rMaterialAnalog 
--				� ��������� ������ � ������� rMaterialLink>
-- =============================================
CREATE TRIGGER Trigger_rMaterialOriginal_Create
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

-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,17/12/2016,>
-- Description:	<����� ������� ������ �� ������� rMaterialOriginal ����� �� ������ ��������� �� ������� rMaterialAnalog 
--				� ������� rMaterialLink>
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

	delete from [dbo].rMaterialAnalog
	where [dbo].rMaterialAnalog.PartNumber = @partnumber


END

GO

-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,25/12/2016,>
-- Description:	<����� ��������� ������ � ������� rModelLink ����������� Custom9 � �������� tblAssetCustom � rAsset ��� ���� ��� ���������
-- rModelLink.ModelAsset � tblAssetCustom.Model>
-- =============================================
create trigger trigger_rModelLink_update
on [dbo].[rModelLink] for update
as
begin
	-- set nocount on added to prevent extra result sets from
	-- interfering with select statements.
	set nocount on;

with c as (
	select 
		ac.AssetID,
		ac.Model,
		ac.Custom9 as Custom9_tgt,
		ml.ModelAsset as Custom9_check,
		ml.ModelSprav as Custom9_src
	
	from inserted as ml 
	inner join dbo.tblAssetCustom as ac on ml.ModelAsset =ac.Model 
)
update c set 
Custom9_tgt = Custom9_src;

with c as (
	select 
		ac.AssetID,
		ac.Model,
		ac.Custom9 as Custom9_tgt,
		ml.ModelAsset as Custom9_check,
		ml.ModelSprav as Custom9_src
	
	from dbo.rModelLink as ml 
	inner join dbo.rAsset as ac on ml.ModelAsset =ac.Model 
)
update c set 
Custom9_tgt = Custom9_src;

end

