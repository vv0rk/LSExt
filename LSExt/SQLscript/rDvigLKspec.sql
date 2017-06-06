use lansweeperdb;

go

/*
	������������ � ������ ��������
*/

if object_id (N'rDvigLKspec') is null
begin;
	CREATE TABLE [dbo].rDvigLKspec
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- ������ �� ������ �������� � ������� ������� Asset
		[idLK] int not null,
		Constraint FK_rDvigLKspec_rDvigLK_idLK_id foreign key (idLK)
			references dbo.rDvigLK (id) on delete cascade,
		-- ������ �� Asset ������� ������� �� ��
		[AssetId] int not null,
		Constraint FK_rDvigLKspec_rAsset_assetid_assetid foreign key (assetid)
			references dbo.tblAssets (Assetid) on delete cascade
	);
end;
