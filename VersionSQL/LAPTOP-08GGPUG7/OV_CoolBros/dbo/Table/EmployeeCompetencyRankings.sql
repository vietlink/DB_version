/****** Object:  Table [dbo].[EmployeeCompetencyRankings]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeCompetencyRankings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShortDescription] [varchar](50) NOT NULL,
	[Description] [varchar](512) NULL,
	[IsEnabled] [bit] NOT NULL,
	[RankingIndex] [int] NOT NULL,
	[ExclFromPosition] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_EmployeeCompetencyRankings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeCompetencyRankings] ADD  CONSTRAINT [DF_EmployeeCompetencyRankings_IsEnabled]  DEFAULT ((1)) FOR [IsEnabled]
ALTER TABLE [dbo].[EmployeeCompetencyRankings] ADD  CONSTRAINT [DF_EmployeeCompetencyRankings_RankingIndex]  DEFAULT ((1)) FOR [RankingIndex]
ALTER TABLE [dbo].[EmployeeCompetencyRankings] ADD  CONSTRAINT [DF_EmployeeCompetencyRankings_ExclFromPosition]  DEFAULT ((0)) FOR [ExclFromPosition]
ALTER TABLE [dbo].[EmployeeCompetencyRankings] ADD  CONSTRAINT [DF_EmployeeCompetencyRankings_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
