/****** Object:  Table [dbo].[LoadingRate]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LoadingRate](
	[ID] [int] NOT NULL,
	[Description] [varchar](300) NOT NULL,
	[Code] [varchar](5) NOT NULL,
	[Value] [decimal](5, 2) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[LoadingRate] ADD  CONSTRAINT [DF_LoadingRate_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
ALTER TABLE [dbo].[LoadingRate] ADD  CONSTRAINT [DF_LoadingRate_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
