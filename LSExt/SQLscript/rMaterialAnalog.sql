
use lansweeperdb;

go

-- ������� � ��������� ��������� ����������
-- ��������� ��������� �� ���� ������� ����������� �� ����������
-- ������� ��������� ���������� ������� � ������������� ���������� ����������� ����� �������
-- rLinkMaterials
if object_id (N'rMaterialAnalog') is null
begin;
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

		-- �������������� ��� � ��������� ShortNameManufacturer space PartNumber
		[AltName] nvarchar(290) NULL,

		-- ���� ������� ����� � �������� rManufacturer �� ���� ShortName
		Constraint FK_rManufacturer_rMaterialAnalog_Id FOREIGN KEY (IdManufacturer)
			References rManufacturer (Id)
	);
end;

-- ��������� ������� AltName
if not exists (
			select * 
			from sys.columns 
			where name = N'AltName')
	begin;
		Alter table rMaterialAnalog add AltName nvarchar(290) Null;
	end;

-- ��������� ���������� ����� ������
drop trigger dbo.Trigger_rMaterialAnalog_Insert
drop trigger dbo.Trigger_rMaterialAnalog_Update
go

Create trigger Trigger_rMaterialAnalog_Insert on dbo.rMaterialAnalog instead of insert
as
	begin;
		insert into dbo.rMaterialAnalog
		(
			IdManufacturer
			, PartNumber
			, Name
			, Resource
			, AltName
		)
		select 
			i.IdManufacturer
			, i.PartNumber
			, i.Name
			, i.Resource
			, CONCAT(m.ShortName, ' ', i.PartNumber)
		from inserted as i 
		inner join dbo.rManufacturer as m on i.IdManufacturer = m.Id
	end;

go 

Create trigger Trigger_rMaterialAnalog_Update on dbo.rMaterialAnalog after update
as
	begin;

		update ma set AltName = CONCAT(m.ShortName, ' ', i.PartNumber)
		from dbo.rMaterialAnalog as ma 
		inner join inserted as i on i.Id = ma.Id
		inner join dbo.rManufacturer as m on i.IdManufacturer = m.Id
	end;



-- �������������� ��� ������������ ������ ������������������ AltName
-- ���� ������ ����������� ������ ��� ������������� ����������������� 
-- ������������ ������
/*
use lansweeperdb;

go

with c as (
select 
	ma.AltName as AltName_tgt
	, CONCAT( m.ShortName, ' ', ma.PartNumber) as AltName_src
from dbo.rMaterialAnalog as ma 
left join dbo.rManufacturer as m on ma.IdManufacturer = m.Id
)
update c set
AltName_tgt = AltName_src;	
*/
