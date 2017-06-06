use lansweeperdb;

go

/*
	спецификация к личной карточке
*/

if object_id (N'rDvigLKspec') is null
begin;
	CREATE TABLE [dbo].rDvigLKspec
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- ссылка на личную карточку в которой записан Asset
		[idLK] int not null,
		Constraint FK_rDvigLKspec_rDvigLK_idLK_id foreign key (idLK)
			references dbo.rDvigLK (id) on delete cascade,
		-- ссылка на Asset который записан на ЛК
		[AssetId] int not null,
		Constraint FK_rDvigLKspec_rAsset_assetid_assetid foreign key (assetid)
			references dbo.tblAssets (Assetid) on delete cascade
	);
end;
