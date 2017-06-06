use lansweeperdb;

go

/*
	�������� ��������� �� ������� ������������ �������� ������������ �� ��
*/

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
create procedure sp_DvigLKtoLK
	@AssetId int = NULL,
	@idLksrc int = NULL,
	@idLKtgt int = NULL,
	@idScladsrc int = NULL,
	@idScladtgt int = NULL

AS
	Set nocount on;

	-- ��������� ��� ������������ �� ��������� ��������� ����� � ��
	IF (@idLKsrc is not null and @idScladsrc is not null) or (@idLKtgt is not null and @idScladtgt is not null) 
		BEGIN
			PRINT N'������������ �� ����� ���� ����������/���������� ����� � ��'
			RETURN (1)
		END

	-- ��������� ��� ������������ �� ��������� � ������������� �����������
	IF EXISTS (
		Select *
		from dbo.rDvigLKspecLog as dlsl
		where dlsl.AssetId = @AssetId and dlsl.isApproved = 0 )
		BEGIN
			PRINT N'���� ���� ��������� � ������������� ���������...';
			PRINT N'��������� ��� ��������� ���������� ����������...';
			RETURN (1)
		END

	-- ��������� ������ � ������
	insert into dbo.rDvigLKspecLog (AssetId, idLKsrc, idLKtgt)
	VALUES (@AssetID, @LKsrc, @LKtgt)
			
	-- ������� ������ �� ���������� �� ���������� ��
	delete from dbo.rDvigLKspec 
	Where dbo.rDvigLKspec.AssetId = @AssetID 

	-- ��������� ������ � ������������ ��� ��������� ��
	insert into dbo.rDvigLKspec (AssetId, idLK)
	VALUES (@AssetID, @LKtgt);
GO