/****** Object:  Table [dbo].[EmployeeEntryGroupRelations]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeEntryGroupRelations](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeEntryGroupID] [int] NOT NULL,
	[AttributeID] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsMandatory] [bit] NOT NULL,
 CONSTRAINT [PK_EmployeeEntreeGroupRelations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeEntryGroupRelations] ADD  CONSTRAINT [DF_EmployeeEntryGroupRelations_IsMandatory]  DEFAULT ((0)) FOR [IsMandatory]
ALTER TABLE [dbo].[EmployeeEntryGroupRelations]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeEntreeGroupRelations_Attribute] FOREIGN KEY([AttributeID])
REFERENCES [dbo].[Attribute] ([id])
ALTER TABLE [dbo].[EmployeeEntryGroupRelations] CHECK CONSTRAINT [FK_EmployeeEntreeGroupRelations_Attribute]
ALTER TABLE [dbo].[EmployeeEntryGroupRelations]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeEntreeGroupRelations_EmployeeEntryGroups] FOREIGN KEY([EmployeeEntryGroupID])
REFERENCES [dbo].[EmployeeEntryGroups] ([ID])
ALTER TABLE [dbo].[EmployeeEntryGroupRelations] CHECK CONSTRAINT [FK_EmployeeEntreeGroupRelations_EmployeeEntryGroups]
