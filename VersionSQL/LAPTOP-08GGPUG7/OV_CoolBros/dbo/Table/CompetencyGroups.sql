/****** Object:  Table [dbo].[CompetencyGroups]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CompetencyGroups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeId] [int] NOT NULL,
	[Code] [varchar](50) NULL,
	[Description] [varchar](500) NULL,
	[SortOrder] [int] NULL,
	[Enabled] [char](1) NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CompetencyGroups]  WITH CHECK ADD  CONSTRAINT [FK_CompetencyGroups_CompetencyTypes] FOREIGN KEY([TypeId])
REFERENCES [dbo].[CompetencyTypes] ([Id])
ALTER TABLE [dbo].[CompetencyGroups] CHECK CONSTRAINT [FK_CompetencyGroups_CompetencyTypes]
