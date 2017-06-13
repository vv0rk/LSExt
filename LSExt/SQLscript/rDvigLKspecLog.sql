use lansweeperdb;

go

/*
	������ ���������� �������� ������������

	���� ���������� ������������ ����� ����������� ������������ � ������ ��������� � ������
	���������� ���������� ����� ����������� ����������� ������ �� ������ ��������� � ������
	���������� ������������� ����� ��� ������������ �� (��� ����� ��� ������ �������� ����������� 
	�������� �������������� �����������, ��������� ��� � ��������� �� ���������� ��������)

	� ������ ����� ���������� �� ������������, ��� ������ ���� �������� ����� �� ���������� �������������� 
	���������. ��������� �������� �����������������. ��������� ������������ ���� � ���������� �� 
	���������� ��������.

	����� ����������� ������ ��� ����������� � ��� ������� ��������� ������ � ����������

*/

if object_id (N'rDvigLKspecLog') is null
begin;
	CREATE TABLE [dbo].rDvigLKspecLog
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		

		-- ������ �� ������ ������� ������������� �� �������������� �����.
		[AssetId] int not null,
		Constraint FK_rAssets_rDvigLKspecLog_AssetId_id foreign key (AssetId)
			references dbo.rAssetsImported (id),

		-- �����������. �������� �� ����� ���� ������������ ����� � ��
		-- ������ �� ��������� � ������� ������������ asset
		[idLKsrc] int null,
		Constraint FK_rDvigLKspecLog_rDvigLK_idLKsrc_id foreign key (idLKsrc)
			references dbo.rDvigLK (id),

		-- ������ �� ��������� �� ������� ������������ asset
		[idLKtgt] int null,
		Constraint FK_rDvigLKspecLog_rDvigLK_idLKtgt_id foreign key (idLKtgt)
			references dbo.rDvigLK (id),

		[idStatus] int not null default 1,
		Constraint FK_rDvigLKspecLog_rDvigLKStatus_idStatus_id foreign key (idStatus)
			references dbo.rDvigLKStatus (id),

		-- ���������� � ������� �������� ������ ����������� � � ������������ ��������� ������
		[username] nvarchar(255) null,
		[datecreate] datetime null,

		-- ���������� � ������������ ������������� ���������� ��������		
		[userapprove] nvarchar(255) null,
		[dateapprove] datetime null,
		[isApproved] bit not null default 0
	);
end;
