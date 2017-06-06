USE [lansweeperdb]
GO

/****** Object:  Table [dbo].[rAssetsKsu]    Script Date: 03.06.2017 18:51:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[rAssetsKsu](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[code] [nvarchar](32) NOT NULL,
	[nomenclatureId] [int] NULL,
	[inventoryNumber] [nvarchar](32) NULL,
	[serialNumber] [nvarchar](32) NULL,
	[mol] [nvarchar](255) NULL,
	[organization] [nvarchar](255) NOT NULL,
	[companyId] [int] NOT NULL,
	[account] [nvarchar](12) NULL,
	[count] [int] NOT NULL,
	[configurationId] [int] NULL,
	[categoryId] [int] NULL,
	[room] [nvarchar](255) NULL,
	[user] [nvarchar](255) NULL,
	[withCategory] [bit] NOT NULL,
	[registrationDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

-- выполнено 
ALTER TABLE [dbo].[rAssetsKsu]  WITH CHECK ADD  CONSTRAINT [FK_rAssetsKsu_rCategory] FOREIGN KEY([categoryId])
REFERENCES [dbo].[rCategory] ([id])
GO

ALTER TABLE [dbo].[rAssetsKsu] CHECK CONSTRAINT [FK_rAssetsKsu_rCategory]
GO

-- выполнено 
ALTER TABLE [dbo].[rAssetsKsu]  WITH CHECK ADD  CONSTRAINT [FK_rAssetsKsu_rCompany] FOREIGN KEY([companyId])
REFERENCES [dbo].[rCompany$] ([id])
GO

ALTER TABLE [dbo].[rAssetsKsu] CHECK CONSTRAINT [FK_rAssetsKsu_rCompany]
GO


-- выполнено 
ALTER TABLE [dbo].[rAssetsKsu]  WITH CHECK ADD  CONSTRAINT [FK_rAssetsKsu_rConfiguration] FOREIGN KEY([configurationId])
REFERENCES [dbo].[rConfiguration] ([id])
GO

ALTER TABLE [dbo].[rAssetsKsu] CHECK CONSTRAINT [FK_rAssetsKsu_rConfiguration]
GO

-- выполнено 
ALTER TABLE [dbo].[rAssetsKsu]  WITH CHECK ADD  CONSTRAINT [FK_rAssetsKsu_rNomenclature] FOREIGN KEY([nomenclatureId])
REFERENCES [dbo].[rNomenclature] ([id])
GO

ALTER TABLE [dbo].[rAssetsKsu] CHECK CONSTRAINT [FK_rAssetsKsu_rNomenclature]
GO

