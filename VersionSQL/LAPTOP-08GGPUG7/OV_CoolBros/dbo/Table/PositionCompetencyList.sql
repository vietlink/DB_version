/****** Object:  Table [dbo].[PositionCompetencyList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PositionCompetencyList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[CompetencyListId] [int] NOT NULL,
	[RankingId] [int] NULL,
	[IsMandatory] [bit] NOT NULL,
 CONSTRAINT [PK_PositionCompetencyList] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PositionCompetencyList] ADD  CONSTRAINT [DF_PositionCompetencyList_IsMandatory]  DEFAULT ((0)) FOR [IsMandatory]
ALTER TABLE [dbo].[PositionCompetencyList]  WITH CHECK ADD  CONSTRAINT [FK_PositionCompetencyList_CompetencyList] FOREIGN KEY([CompetencyListId])
REFERENCES [dbo].[CompetencyList] ([Id])
ALTER TABLE [dbo].[PositionCompetencyList] CHECK CONSTRAINT [FK_PositionCompetencyList_CompetencyList]
ALTER TABLE [dbo].[PositionCompetencyList]  WITH CHECK ADD  CONSTRAINT [FK_PositionCompetencyList_Position] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([id])
ALTER TABLE [dbo].[PositionCompetencyList] CHECK CONSTRAINT [FK_PositionCompetencyList_Position]
