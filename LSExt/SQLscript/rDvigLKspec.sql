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
		Constraint FK_rDvigLKspec_rAssetsImported_assetid_id foreign key (assetid)
			references dbo.rAssetsImported (Id) on delete cascade,
		Constraint AK_rDvigLKSpec_AssetId unique (AssetId),

		-- ������ �� ������ � ������������ � ������� ���� �����������
		[idLog] int not null,
		Constraint FK_rDvigLKspec_rDvigLKspecLog_idLog_id foreign key (idLog)
			references dbo.rDvigLKspecLog (id)
	);
end;
