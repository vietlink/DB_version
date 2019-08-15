/****** Object:  Table [dbo].[OrgChartEntryGroupRelations]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrgChartEntryGroupRelations](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrgChartEntryGroupID] [int] NOT NULL,
	[AttributeID] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsMandatory] [bit] NOT NULL,
 CONSTRAINT [PK_OrgViewEntryGroupRelations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrgChartEntryGroupRelations]  WITH CHECK ADD  CONSTRAINT [FK_OrgChartEntryGroupRelations_Attribute] FOREIGN KEY([AttributeID])
REFERENCES [dbo].[Attribute] ([id])
ALTER TABLE [dbo].[OrgChartEntryGroupRelations] CHECK CONSTRAINT [FK_OrgChartEntryGroupRelations_Attribute]
ALTER TABLE [dbo].[OrgChartEntryGroupRelations]  WITH CHECK ADD  CONSTRAINT [FK_OrgChartEntryGroupRelations_OrgChartEntryGroups] FOREIGN KEY([OrgChartEntryGroupID])
REFERENCES [dbo].[OrgChartEntryGroups] ([ID])
ALTER TABLE [dbo].[OrgChartEntryGroupRelations] CHECK CONSTRAINT [FK_OrgChartEntryGroupRelations_OrgChartEntryGroups]
