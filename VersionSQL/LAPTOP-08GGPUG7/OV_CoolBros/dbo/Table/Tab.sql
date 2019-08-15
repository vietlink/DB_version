/****** Object:  Table [dbo].[Tab]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tab](
	[Id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[Name] [dbo].[udtCode] NOT NULL,
	[Enable] [dbo].[udtYesNo] NOT NULL,
	[TabOrder] [dbo].[udtInteger] NOT NULL,
	[usereditable] [char](1) NULL,
	[ProfileTab] [bit] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Tab] ADD  CONSTRAINT [DF_Tab_ProfileTab]  DEFAULT ((0)) FOR [ProfileTab]
