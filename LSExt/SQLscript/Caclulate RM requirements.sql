use lansweeperdb;

go 

/*
	эта таблица показывает развертку отпечатанных страниц за месяц для 
	каждого Assets
*/
select 
	AssetId
	, [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]
--	, p.PrintedPages
from (
	select 
		a.AssetID as AssetId
		--, m.mYear as mYear
		, m.mMonth as mmonth
		, max(m.PrintedPages) as PrintedPages

	from dbo.tblAssets as a 
	inner join dbo.tblAssetCustom as ac on a.assetid = ac.AssetId 
	Inner Join tsysAssetTypes As at On a.Assettype = at.AssetType and at.AssetTypename = 'Printer'
	Inner Join tblState As stt On ac.State = stt.State
	inner join (
		select 
			ph.AssetId as AssetId
			, Year(ph.datecheck) as mYear
			, Month(ph.datecheck) as mMonth
			, max(ph.PrintedPages) - min (ph.printedpages) as PrintedPages
		from dbo.rPrintHist as ph
		Group by ph.AssetId, Year(ph.datecheck), Month(ph.datecheck)
	) as m on a.AssetID = m.AssetId
	group by a.AssetID, m.mMonth
) as p

pivot
(
	max(p.PrintedPages)
	for p.mmonth in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) as pvt

order by pvt.AssetId

-- этот запрос выводит модели с расходными материалами и раскладкой с отпечатанными страницами 
-- рабочая версия
-- Lansweeper не может обработать запрос Pivot, поэтому выводиться будет в Lansweeper 
-- через промежуточную таблицу rMaterialSvod 
-- из этой таблицы в макросе рассчитывается таблица rMaterialSvodRes
-- ключем является AssetId, PartNumber
-- это будет рабочая таблица в которую данные будут добавляеться и удаляться периодический
-- и дозированно при помощи запросов
select 
	a.AssetID
	, mo.ModelSprav
	, ac.Model
	, mo.PartNumber
	, [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]

from dbo.tblAssets as a 
inner join dbo.tblAssetCustom as ac on a.assetid = ac.AssetId 
Inner Join tsysAssetTypes As at On a.Assettype = at.AssetType and at.AssetTypename = 'Printer'
inner join (
	select 
		AssetId
		, [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]
	--	, p.PrintedPages
	from (
		select 
			a.AssetID as AssetId
			--, m.mYear as mYear
			, m.mMonth as mmonth
			, max(m.PrintedPages) as PrintedPages

		from dbo.tblAssets as a 
		inner join dbo.tblAssetCustom as ac on a.assetid = ac.AssetId 
		Inner Join tsysAssetTypes As at On a.Assettype = at.AssetType and at.AssetTypename = 'Printer'
		Inner Join tblState As stt On ac.State = stt.State
		inner join (
			select 
				ph.AssetId as AssetId
				, Year(ph.datecheck) as mYear
				, Month(ph.datecheck) as mMonth
				, max(ph.PrintedPages) - min (ph.printedpages) as PrintedPages
			from dbo.rPrintHist as ph
			Group by ph.AssetId, Year(ph.datecheck), Month(ph.datecheck)
		) as m on a.AssetID = m.AssetId
		group by a.AssetID, m.mMonth
	) as p

	pivot
	(
		max(p.PrintedPages)
		for p.mmonth in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
	) as pvt
) as pvt on a.AssetID = pvt.AssetId
left join (
	select 
	mo.PartNumber
	, mo.Resource as Resourc
	, md.Model as ModelSprav
	, ml.ModelAsset as ModelAsset

	from dbo.rMaterialOriginal as mo
	inner join dbo.rModelComplect as mc on mo.Id = mc.IdMaterialOriginal 
	inner join dbo.rModelComplectStatus as mcs on mcs.Id = mc.IdStatus and mcs.Status = N'ДА'
	inner join dbo.rModelDevice as md on mc.IdModel = md.Id
	inner join dbo.rModelLink as ml on ml.ModelSprav = md.Model
) as mo on ac.Model = mo.ModelAsset

/*		rMaterialSvodRes ВНЕСЕНО В ПРОДАКШН
	промежуточная таблица, в которую выводятся результаты расчета единиц расходных материалов в штуках
	заполняется по данным из таблицы rMaterialSvodRes
*/
Create table rMaterialSvodRes
(
	Id int not null identity(1,1) primary key,
	AssetId int not null,
	ModelSprav nvarchar(255) null,
	ModelAsset nvarchar(255) null,
	PartNumber nvarchar(100) null,
	Resource int null,
	IdSclad int null,
	Constraint FK_rMaterialSvod_rSclad_IdSclad foreign key (IdSclad)
		references rSclad(Id),
	PercentRes int not null default 100,
	ScladRemain int null,
	Intence float(24) not null default 1,
	Januar int null, 
	Februar int null, 
	March int null, 
	April int null, 
	May int null, 
	June int null , 
	July int null, 
	August int null, 
	September int null,
	October int null,
	November int null,
	December int null
)


/*		rMaterialRashod ВНЕСЕНО В ПРОДАКШН
	промежуточная таблица, в которую выводятся результаты расчета отпечатанных страниц rMaterialSvod
*/
Create table rMaterialSvod
(
	Id int not null identity(1,1) primary key,
	AssetId int not null,
	ModelSprav nvarchar(255) null,
	ModelAsset nvarchar(255) null,
	PartNumber nvarchar(100) null,
	Resource int null,
	IdSclad int null,
	Constraint FK_rMaterialSvod_rSclad_IdSclad foreign key (IdSclad)
		references rSclad(Id),
	PercentRes int not null default 100,
	ScladRemain int null,
	Intence float(24) not null default 1,
	Januar int null, 
	Februar int null, 
	March int null, 
	April int null, 
	May int null, 
	June int null , 
	July int null, 
	August int null, 
	September int null,
	October int null,
	November int null,
	December int null
)

-- Модификация таблиц rMaterialSvod и rMaterialSvodRes
alter table rMaterialSvod add IdSclad int null;
alter table rMaterialSvod add Constraint FK_rMaterialSvod_rSclad_IdSclad foreign key (IdSclad) references rSclad(Id);
alter table rMaterialSvod add PercentRes int not null default 100;
alter table rMaterialSvod add ScladRemain int null;
alter table rMaterialSvod add Intence float(24) not null default 1;

alter table rMaterialSvodRes add IdSclad int null;
alter table rMaterialSvodRes add Constraint FK_rMaterialSvodRes_rSclad_IdSclad foreign key (IdSclad) references rSclad(Id);
alter table rMaterialSvodRes add PercentRes int not null default 100;
alter table rMaterialSvodRes add ScladRemain int null;
alter table rMaterialSvodRes add Intence float(24) not null default 1;



/* FillrMaterialSvod
Заполняем таблицу rMaterialSvod 
*/
insert into dbo.rMaterialSvod 
(
	AssetId,
	ModelSprav,
	ModelAsset,
	PartNumber,
	Resource,
	Januar, 
	Februar, 
	March, 
	April, 
	May, 
	June , 
	July, 
	August, 
	September,
	October,
	November,
	December
)
select 
	a.AssetID
	, mo.ModelSprav
	, ac.Model
	, mo.PartNumber
	, mo.Resourc
	, [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]

from dbo.tblAssets as a 
inner join dbo.tblAssetCustom as ac on a.assetid = ac.AssetId 
Inner Join tsysAssetTypes As at On a.Assettype = at.AssetType and at.AssetTypename = 'Printer'
inner join (
	select 
		AssetId
		, [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]
	--	, p.PrintedPages
	from (
		select 
			a.AssetID as AssetId
			--, m.mYear as mYear
			, m.mMonth as mmonth
			, max(m.PrintedPages) as PrintedPages

		from dbo.tblAssets as a 
		inner join dbo.tblAssetCustom as ac on a.assetid = ac.AssetId 
		Inner Join tsysAssetTypes As at On a.Assettype = at.AssetType and at.AssetTypename = 'Printer'
		Inner Join tblState As stt On ac.State = stt.State
		inner join (
			select 
				ph.AssetId as AssetId
				, Year(ph.datecheck) as mYear
				, Month(ph.datecheck) as mMonth
				, max(ph.PrintedPages) - min (ph.printedpages) as PrintedPages
			from dbo.rPrintHist as ph
			Group by ph.AssetId, Year(ph.datecheck), Month(ph.datecheck)
		) as m on a.AssetID = m.AssetId
		group by a.AssetID, m.mMonth
	) as p

	pivot
	(
		max(p.PrintedPages)
		for p.mmonth in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
	) as pvt
) as pvt on a.AssetID = pvt.AssetId
left join (
	select 
	mo.PartNumber
	, mo.Resource as Resourc
	, md.Model as ModelSprav
	, ml.ModelAsset as ModelAsset

	from dbo.rMaterialOriginal as mo
	inner join dbo.rModelComplect as mc on mo.Id = mc.IdMaterialOriginal 
	inner join dbo.rModelComplectStatus as mcs on mcs.Id = mc.IdStatus and mcs.Status = N'ДА'
	inner join dbo.rModelDevice as md on mc.IdModel = md.Id
	inner join dbo.rModelLink as ml on ml.ModelSprav = md.Model
) as mo on ac.Model = mo.ModelAsset

/*  ВНЕСЕНО В ПРОДАКШН
Таблица связи Assets и Склад 
*/
Create table rAssetsScladLink
(
	Id int not null identity(1,1) primary key,
	AssetID int not null,
	Constraint FK_rAssetsLink_rAsset_rAssetID foreign key (AssetId) 
		references rAsset (AssetId),
	IdSclad int null
)

/*  ВНЕСЕНО В ПРОДАКШН
	Таблица остатков материалов на складах
	rScladMaterialOriginal
*/
Create table rScladMaterialOriginal
(
	Id int not null Identity(1,1) primary key,
	IdSclad int not null,
	Constraint FK_rScladMaterialOriginal_rSclad_IdSclad foreign key (IdSclad)
		references rSclad(Id),
	IdMaterialOriginal int not null,
	Constraint FK_rScladMaterialOriginal_rMaterialOriginal_IdMaterialOriginal foreign key (IdMaterialOriginal)
		references rMaterialOriginal(Id),
	Number int null
)
