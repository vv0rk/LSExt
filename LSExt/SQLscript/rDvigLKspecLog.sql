use lansweeperdb;

go

/*
	������ �������� ������������
*/

if object_id (N'rDvigLKspecLog') is null
begin;
	CREATE TABLE [dbo].rDvigLKspecLog
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		

		-- ������ �� Asset ������� ������������
		[AssetId] int not null,
		Constraint FK_rDvigLKspec_tblAssets_assetid_assetid foreign key (assetid)
			references dbo.tblAssets (Assetid),

		-- �����������. �������� �� ����� ���� ������������ ����� � ��
		-- ������ �� ������ �������� � ������� ������������ asset
		[idLKsrc] int null,
		Constraint FK_rDvigLKspecLog_rDvigLK_idLKsrc_id foreign key (idLKsrc)
			references dbo.rDvigLK (id),
		-- ������ �� ������ �������� �� ������� ������������ asset
		[idLKtgt] int null,
		Constraint FK_rDvigLKspecLog_rDvigLK_idLKtgt_id foreign key (idLKtgt)
			references dbo.rDvigLK (id),

		-- �����������. �������� �� ����� ���� ������������ ����� � ��
		-- ������ �� ����� � �������� ������������ asset
		[idScladsrc] int null,
		Constraint FK_rDvigLKspecLog_rSclad_idScladsrc_id foreign key (idScladsrc)
			references dbo.rSclad (id),
		-- ������ �� ����� �� ������� ������������ asset
		[idScladtgt] int null,
		Constraint FK_rDvigLKspecLog_rSclad_idScladtgt_id foreign key (idScladtgt)
			references dbo.rSclad (id),

		-- ���������� � ������� �������� ������ ����������� � � ������������ ��������� ������
		[username] nvarchar(255) null,
		[datecreate] datetime null,

		-- ���������� � ������������ ������������� ���������� ��������		
		[userapprove] nvarchar(255) null,
		[dateapprove] datetime null,
		[isApproved] bit not null default 0



	);
end;
