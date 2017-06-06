USE [lansweeperdb]
GO

/****** Object:  Table [dbo].[rAssetsImported]    Script Date: 03.06.2017 19:00:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[rAssetsImported](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[assetKsuId] [int] NOT NULL,
	[assetId] [int] NULL,
	[assetCustomId] [int] NULL,
	[isLinked] [bit] NOT NULL,
	[inventoryNumber] [nvarchar](32) NULL,
	[serialNumber] [nvarchar](32) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[rAssetsImported]  WITH CHECK ADD  CONSTRAINT [FK_rAssetsImported_rAssetsKsu] FOREIGN KEY([assetKsuId])
REFERENCES [dbo].[rAssetsKsu] ([id])
GO

ALTER TABLE [dbo].[rAssetsImported] CHECK CONSTRAINT [FK_rAssetsImported_rAssetsKsu]
GO

ALTER TABLE [dbo].[rAssetsImported]  WITH CHECK ADD  CONSTRAINT [FK_rAssetsImported_tblAssetCustom] FOREIGN KEY([assetCustomId])
REFERENCES [dbo].[tblAssetCustom] ([CustID])
GO

ALTER TABLE [dbo].[rAssetsImported] CHECK CONSTRAINT [FK_rAssetsImported_tblAssetCustom]
GO

ALTER TABLE [dbo].[rAssetsImported]  WITH CHECK ADD  CONSTRAINT [FK_rAssetsImported_tblAssets] FOREIGN KEY([assetId])
REFERENCES [dbo].[tblAssets] ([AssetID])
GO

ALTER TABLE [dbo].[rAssetsImported] CHECK CONSTRAINT [FK_rAssetsImported_tblAssets]
GO

