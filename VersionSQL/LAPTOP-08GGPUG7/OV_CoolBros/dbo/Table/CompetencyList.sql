/****** Object:  Table [dbo].[CompetencyList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CompetencyList](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompetencyGroupId] [int] NOT NULL,
	[CompetencyId] [int] NOT NULL,
	[SortOrder] [int] NULL,
	[Enabled] [char](1) NULL,
 CONSTRAINT [PK_CategoryDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CompetencyList]  WITH CHECK ADD  CONSTRAINT [FK_CompetencyList_Competencies] FOREIGN KEY([CompetencyId])
REFERENCES [dbo].[Competencies] ([Id])
ALTER TABLE [dbo].[CompetencyList] CHECK CONSTRAINT [FK_CompetencyList_Competencies]
ALTER TABLE [dbo].[CompetencyList]  WITH CHECK ADD  CONSTRAINT [FK_CompetencyList_CompetencyGroups] FOREIGN KEY([CompetencyGroupId])
REFERENCES [dbo].[CompetencyGroups] ([Id])
ALTER TABLE [dbo].[CompetencyList] CHECK CONSTRAINT [FK_CompetencyList_CompetencyGroups]
