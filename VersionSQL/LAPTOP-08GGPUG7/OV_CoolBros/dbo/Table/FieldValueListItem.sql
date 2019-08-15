/****** Object:  Table [dbo].[FieldValueListItem]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FieldValueListItem](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](100) NOT NULL,
	[FieldValueListID] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Grouping] [varchar](50) NULL,
 CONSTRAINT [PK_FieldValueListItem] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FieldValueListItem] ADD  CONSTRAINT [DF_FieldValueListItem_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
ALTER TABLE [dbo].[FieldValueListItem]  WITH CHECK ADD  CONSTRAINT [FK_FieldValueListItem_FieldValueList] FOREIGN KEY([FieldValueListID])
REFERENCES [dbo].[FieldValueList] ([ID])
ALTER TABLE [dbo].[FieldValueListItem] CHECK CONSTRAINT [FK_FieldValueListItem_FieldValueList]
