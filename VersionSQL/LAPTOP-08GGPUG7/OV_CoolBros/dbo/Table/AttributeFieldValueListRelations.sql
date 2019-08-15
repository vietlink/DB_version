/****** Object:  Table [dbo].[AttributeFieldValueListRelations]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AttributeFieldValueListRelations](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AttributeID] [int] NOT NULL,
	[FieldValueListID] [int] NOT NULL,
 CONSTRAINT [PK_AttributeFieldValueRelations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AttributeFieldValueListRelations]  WITH CHECK ADD  CONSTRAINT [FK_AttributeFieldValueListRelations_Attribute] FOREIGN KEY([AttributeID])
REFERENCES [dbo].[Attribute] ([id])
ALTER TABLE [dbo].[AttributeFieldValueListRelations] CHECK CONSTRAINT [FK_AttributeFieldValueListRelations_Attribute]
ALTER TABLE [dbo].[AttributeFieldValueListRelations]  WITH CHECK ADD  CONSTRAINT [FK_AttributeFieldValueListRelations_FieldValueList] FOREIGN KEY([FieldValueListID])
REFERENCES [dbo].[FieldValueList] ([ID])
ALTER TABLE [dbo].[AttributeFieldValueListRelations] CHECK CONSTRAINT [FK_AttributeFieldValueListRelations_FieldValueList]
