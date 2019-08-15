/****** Object:  Table [dbo].[Status]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Status](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IsVisibleChart] [bit] NOT NULL,
	[Code] [varchar](10) NULL,
	[Description] [varchar](100) NOT NULL,
	[Type] [varchar](100) NOT NULL,
	[DoSoftDelete] [bit] NOT NULL,
	[IsAddStatus] [bit] NOT NULL,
	[IsDefaultFilter] [bit] NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Status] ADD  CONSTRAINT [DF_Status_DoSoftDelete]  DEFAULT ((0)) FOR [DoSoftDelete]
ALTER TABLE [dbo].[Status] ADD  CONSTRAINT [DF_Status_IsAddStatus]  DEFAULT ((0)) FOR [IsAddStatus]
ALTER TABLE [dbo].[Status] ADD  CONSTRAINT [DF_Status_IsDefaultFilter]  DEFAULT ((0)) FOR [IsDefaultFilter]
