/****** Object:  Table [dbo].[PositionEntryGroups]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PositionEntryGroups](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsAddGroup] [bit] NULL,
	[IsSystemGroup] [bit] NOT NULL,
 CONSTRAINT [PK_PositionEntryGroups] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PositionEntryGroups] ADD  CONSTRAINT [DF_PositionEntryGroups_IsSystemGroup]  DEFAULT ((0)) FOR [IsSystemGroup]
