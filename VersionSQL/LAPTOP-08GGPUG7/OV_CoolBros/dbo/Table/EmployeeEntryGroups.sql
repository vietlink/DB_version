/****** Object:  Table [dbo].[EmployeeEntryGroups]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeEntryGroups](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsAddGroup] [bit] NOT NULL,
	[IsSystemGroup] [bit] NOT NULL,
 CONSTRAINT [PK_EmployeeEntreeGroups] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeEntryGroups] ADD  CONSTRAINT [DF_EmployeeEntryGroups_IsAddGroup]  DEFAULT ((0)) FOR [IsAddGroup]
ALTER TABLE [dbo].[EmployeeEntryGroups] ADD  CONSTRAINT [DF_EmployeeEntryGroups_IsSystemGroup]  DEFAULT ((0)) FOR [IsSystemGroup]
