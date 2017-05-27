use lansweeperdb;

go

/*
	
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,27/05/2017,>
/* Description:	<����������� ����������� �� ���� ���������� � ����������, 
				������ ������ ���� ��� ����������� ����������,
				��������� ������ � ��� �����>
*/
-- =============================================
CREATE TRIGGER Trigger_tblAssets_rActiveCategory1
on [dbo].[tblAssets] FOR DELETE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (
				select * 
				from deleted as a
				inner join dbo.rActiveCategory1 as ac on a.AssetID = ac.AssetId
				)
	BEGIN
		RAISERROR (N'���� ����� ������ � ����������� rActiveCategory1 � �������� � ��������',10,1)
		ROLLBACK TRANSACTION
	END


END

GO
