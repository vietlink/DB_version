/****** Object:  Table [dbo].[PositionEntryGroupRelations]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PositionEntryGroupRelations](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PositionEntryGroupID] [int] NOT NULL,
	[AttributeID] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsMandatory] [bit] NOT NULL,
 CONSTRAINT [PK_PositionEntryGroupRelations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PositionEntryGroupRelations] ADD  CONSTRAINT [DF_PositionEntryGroupRelations_IsMandatory]  DEFAULT ((0)) FOR [IsMandatory]
ALTER TABLE [dbo].[PositionEntryGroupRelations]  WITH CHECK ADD  CONSTRAINT [FK_PositionEntryGroupRelations_Attribute] FOREIGN KEY([AttributeID])
REFERENCES [dbo].[Attribute] ([id])
ALTER TABLE [dbo].[PositionEntryGroupRelations] CHECK CONSTRAINT [FK_PositionEntryGroupRelations_Attribute]
ALTER TABLE [dbo].[PositionEntryGroupRelations]  WITH CHECK ADD  CONSTRAINT [FK_PositionEntryGroupRelations_PositionEntryGroups] FOREIGN KEY([PositionEntryGroupID])
REFERENCES [dbo].[PositionEntryGroups] ([ID])
ALTER TABLE [dbo].[PositionEntryGroupRelations] CHECK CONSTRAINT [FK_PositionEntryGroupRelations_PositionEntryGroups]
