
use lansweeperdb;

go

/*
»нформиац€и об оригинальных расхдоных материалах
*/

if OBJECT_ID (N'rMaterialOriginal') is null
	begin;
		Create table rMaterialOriginal
		(
			[Id] int not null primary key,
			[PartNumber] nvarchar(100) not null,
			Constraint AK_rMaterialOriginal_PartNumber UNIQUE (PartNumber),
			[Name] nvarchar(255) not null,
			[Resource] int null,
			[IdManufacturer] int null,
			Constraint FK_rManufacturer_rMaterialOriginal_IdManufacturer Foreign Key (IdManufacturer)
				References rManufacturer(Id)
		)
	end;

