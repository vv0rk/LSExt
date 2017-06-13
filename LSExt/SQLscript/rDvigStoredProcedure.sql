use lansweeperdb;

go

/*
	�������� ��������� �� ������� ������������ �������� ������������ �� ��
*/

/*
	���������� �������� ������ rDvigLKspec 
*/
alter function fn_DvigLKgetSpec ( @idLk int = NULL )
	returns table 
	as return (
		select 
			d.Id
			, n.code
			, ak.name
			, e.title
			, ai.AssetId
			, ai.inventoryNumber
			, ai.serialNumber
			, c.parent

		from rDvigLK as d
		inner join rDvigLKspec as ds on d.Id = ds.idLK
		inner join rAssetsImported as ai on ds.AssetId = ai.id
		inner join rAssetsKsu as ak on ai.assetKsuId = ak.id
		inner join rNomenclature as n on ak.nomenclatureId = n.id
		left join rCompany$ as c on d.idCompany = c.Id
		inner join rEmployee as e on d.idResponce = e.id
		left join tblAssets as a on ai.assetId = a.AssetID
		where d.Id = @idLK
	)

GO


/*
	������� ���������� �������� ������� ��� ������ 
	��������� �� ����� ����������� � ������ 
*/
alter function fn_DvigLKgetAssets ( @org nvarchar(255) = NULL )
	returns table 
	as return (
		select 
			ai.id
			, n.code as nomCode
			, n.name
			, ai.inventoryNumber
			, ai.serialNumber
			, ai.assetId
			, c.Code as company

		from rAssetsImported as ai 
		inner join rAssetsKsu as ak on ai.assetKsuId = ak.id
		inner join rNomenclature as n on ak.nomenclatureId = n.id
		inner join rCompany$ as c on ak.companyId = c.id
		left join tblAssets as a on ai.assetId = a.AssetID
		where c.Code = @org
	)
GO

/*
	������� ��� �������� ������ � ����������� � Log
*/
Alter procedure sp_DvigLKcreateLog (	@AssetId int = NULL, 
										@idLKsrc int = NULL, 
										@idLKtgt int = NULL, 
										@username nvarchar(255) = NULL,
										@datecreate datetime = NULL
									)
AS
	BEGIN
		SELECT @username = SYSTEM_USER, @datecreate = GETDATE()

		IF @idLKsrc is null or @idLKtgt is null or @AssetId is null 
			BEGIN
				PRINT N'��������, ���� � ����� id �� ����� ���� NULL';
				return 1;
			END

		INSERT INTO dbo.rDvigLKspecLog ( AssetId, idLKsrc, idLKtgt, idStatus, username, datecreate)
		VALUES (@AssetId, @idLKsrc, @idLKtgt, 1, @username, @datecreate)

		return 0;
	END;
GO





/* ��������� ��� ������������ ����������� ������������ 
	�������� ������
	������������ �� ����� ������������ ������ �� ������ � ��
	������������ �� ����� ������������ ���� ������� �� ����� � ��

	������������ ������� ��������� � ������������� ����������, 
	�� ����� ����������� � ������ ����������.

	AssetId - ������������� ����������, ������� ������������

	idLKsrc - ������������� �� � ������� ����������� ������������
	idLKtgt - ������������� �� �� ������� ������������ �����������

	idScladSrc - ������������� ������ � �������� ����������� ������������
	idScladTgt - ������������� ������ �� ������� ������������ ��������
*/
--create procedure sp_DvigLKtoLK
--	@AssetId int = NULL,
--	@idLksrc int = NULL,
--	@idLKtgt int = NULL,
--	@idScladsrc int = NULL,
--	@idScladtgt int = NULL

--AS
--	Set nocount on;

--	-- ��������� ��� ������������ �� ��������� ��������� ����� � ��
--	IF (@idLKsrc is not null and @idScladsrc is not null) or (@idLKtgt is not null and @idScladtgt is not null) 
--		BEGIN
--			PRINT N'������������ �� ����� ���� ����������/���������� ����� � ��'
--			RETURN (1)
--		END

--	-- ��������� ��� ������������ �� ��������� � ������������� �����������
--	IF EXISTS (
--		Select *
--		from dbo.rDvigLKspecLog as dlsl
--		where dlsl.AssetId = @AssetId and dlsl.isApproved = 0 )
--		BEGIN
--			PRINT N'���� ���� ��������� � ������������� ���������...';
--			PRINT N'��������� ��� ��������� ���������� ����������...';
--			RETURN (1)
--		END

--	-- ��������� ������ � ������
--	insert into dbo.rDvigLKspecLog (AssetId, idLKsrc, idLKtgt)
--	VALUES (@AssetID, @LKsrc, @LKtgt)
			
--	-- ������� ������ �� ���������� �� ���������� ��
--	delete from dbo.rDvigLKspec 
--	Where dbo.rDvigLKspec.AssetId = @AssetID 

--	-- ��������� ������ � ������������ ��� ��������� ��
--	insert into dbo.rDvigLKspec (AssetId, idLK)
--	VALUES (@AssetID, @LKtgt);
--GO