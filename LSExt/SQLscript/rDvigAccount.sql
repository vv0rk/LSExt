use lansweeperdb;

go

/*
	� ������� ����������� �������� ���
*/

if object_id (N'rDvigControl') is null
begin;
	CREATE TABLE [dbo].rDvigControl
	(
		[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,		
		-- AssetId ������������� ���������� ������� ���������
		[AssetId] int not null,
		Constraint FK_rDvigControl_tblAssets_AssetId_AssetId foreign key (AssetId)
			references dbo.tblAssets (AssetId),

		-- ��� �������� ���� ������� ����������� �������� ��� ���� ����� ���� ������ ����� ��� ������������
		-- ��� ��������� ����� ����������� ���� ������ ������

		-- rEmployee �� �������, �������� ������� Bigint � Access �������� �� ����� 
		-- rEmployeeMod ��� ����� ��� ������ � Access ����� ���������� ��� ��� 26000 ����������� 
		-- int � tsql ������������ �� 2 147 483 647 (4 �����)
		-- ��� ����������� ���������� ���������� ���������� ������� ������ sql
		[idSourcePers] int null,
		Constraint FK_rDvigControl_rEmployeeMod_idSourcePers_id foreign key (IdSourcePers)
			references dbo.rEmployeeMod(id),
		[idTargetPers] int null,
		Constraint FK_rDvigControl_rEmployeeMod_idTargetPers_id foreign key (idTargetPers)
			references dbo.rEmployeeMod(id),

		-- ��� ����� ����������� �� �� ������������ � �� �����
		-- ������� �������� ������� rSclad
		[idSourceSclad] int null,
		Constraint FK_rDvigControl_rSclad_idSourceSclad_id foreign key (idSourceSclad)
			references dbo.rSclad(id),
		[idTargetSclad] int null,
		Constraint FK_rDvigControl_rSclad_idTargetSclad_id foreign key (idTargetSclad)
			references dbo.rSclad(id),

		-- ��� ������� ���������� ������ ������ ��������� � ����
		[CitySource] nvarchar(100) null,
		[CityTarget] nvarchar(100) null,

		[AddressSource] nvarchar(255) null,
		[AssressTarget] nvarchar(255) null,

		-- ��������� ������������ �����������
		-- ����������� ������������� �� ��������
		[Initiator] nvarchar(150) not null,
		-- ���� ��������� ������� ����������� �� ����� (� ������ ������ �������� � Initiator
		[idInitiator] int not null,
		Constraint FK_rDvigControl_rEmployeeMod_idInitiator_id foreign key (idInitiator)
			references dbo.rEmployeeMod(id),
		
		-- ����������� �����������
		[IsApproved] bit default 0,
		-- ����������� ������������� �� �������� ��� �����������
		[Approved] nvarchar(150) not null,
		-- ���� ��������� ������� ����������� �� ����� (� ������ ������ �������� � idApproved
		[idApproved] int not null,
		Constraint FK_rDvigControl_rEmployeeMod_idApproved_id foreign key (idApproved)
			references dbo.rEmployeeMod(id),

	);
end;
