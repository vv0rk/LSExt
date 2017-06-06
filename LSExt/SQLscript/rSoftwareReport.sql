
use lansweeperdb;

go

if object_id (N'rSoftwareReport') is null
begin;
	Create table dbo.rSoftwareReport (
		Id int not null identity(1,1) primary key,

		Parent nvarchar(255) null,
		Custom1 nvarchar(255) null,
		LicenseOwner nvarchar(255) null,
		softwareName nvarchar(255) null,
		reqLicNumber int null,
		isRequired nvarchar(20) null default N'ДА',
		sku nvarchar(255) null,
		recNomencl nvarchar(255) null,
		recNumLic int null default 1,
		Custom11 nvarchar(255) null,
		AssetName nvarchar(255) null,
		AssetID int null,
		Statename nvarchar(255) null,
		Custom19 nvarchar(255) null,
		keycomp nvarchar(255) null,
		rr int null
	)
end;


-- заполняет лицензии

insert into rSoftwareReport (
Parent
,Custom1
,LicenseOwner
,softwareName
,reqLicNumber
,isRequired
,sku
,recNomencl
,recNumLic
,Custom11
,AssetName
,AssetID
,Statename
,Custom19
,keycomp
,rr
)
	select 
		rc.Parent
		, ac.Custom1
		, lic.LicenseOwner
		, su.softwareName
		, '' as reqLicNumber
		, N'ДА' as isRequired
		, '' as sku
		, lic.SoftName as recNomencl
		, 1 as recNumLic
		, ac.Custom11 as Custom11
		, a.AssetName as AssetName
		, a.AssetID as AssetID
		, st.Statename as Statename
		, ac.Custom19 as Custom19
		, lic.SoftName + convert(nvarchar(20),a.AssetID) as keycomp
		, ROW_NUMBER () over( partition by lic.SoftName + convert(nvarchar(20),a.AssetID) order by a.AssetID desc) as rr
	from tblSoftware as s
	inner join tblSoftwareUni as su on s.softID = su.SoftID
	inner join tblAssetCustom as ac on s.AssetID = ac.AssetID
	inner join tblAssets as a on ac.AssetID = a.AssetID
	inner join tblState as st on ac.State = st.State
	inner join rCompany$ as rc on ac.Custom1 = rc.Code
	inner join (
		select 
			sl.softwareName
			, sl.softwareVersion
			, l.softwareName as SoftName
			, l.LicenseOwner as LicenseOwner
		from tblSublicenses as sl
		inner join tblLicenses as l on sl.LicenseidID = l.LicenseidID
	) as lic on ( su.softwareName = lic.softwareName ) and ( s.softwareVersion = lic.softwareVersion )
) as lll

where lll.rr = 1 