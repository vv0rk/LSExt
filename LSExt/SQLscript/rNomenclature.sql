USE [lansweeperdb]
GO

/****** Object:  Table [dbo].[rNomenclature]    Script Date: 03.06.2017 18:58:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[rNomenclature](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](12) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[parentCode] [nvarchar](12) NULL,
	[parentId] [int] NULL,
	[configurationId] [int] NULL,
	[categoryId] [int] NULL,
	[withCategory] [bit] NOT NULL,
	[count] [int] NOT NULL,
	[isGroup] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[rNomenclature]  WITH NOCHECK ADD  CONSTRAINT [FK_rNomenclature_parent] FOREIGN KEY([parentId])
REFERENCES [dbo].[rNomenclature] ([id])
GO

ALTER TABLE [dbo].[rNomenclature] CHECK CONSTRAINT [FK_rNomenclature_parent]
GO

ALTER TABLE [dbo].[rNomenclature]  WITH CHECK ADD  CONSTRAINT [FK_rNomenclature_rCategory] FOREIGN KEY([categoryId])
REFERENCES [dbo].[rCategory] ([id])
GO

ALTER TABLE [dbo].[rNomenclature] CHECK CONSTRAINT [FK_rNomenclature_rCategory]
GO

ALTER TABLE [dbo].[rNomenclature]  WITH CHECK ADD  CONSTRAINT [FK_rNomenclature_rConfiguration] FOREIGN KEY([configurationId])
REFERENCES [dbo].[rConfiguration] ([id])
GO

ALTER TABLE [dbo].[rNomenclature] CHECK CONSTRAINT [FK_rNomenclature_rConfiguration]
GO

