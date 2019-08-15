/****** Object:  Table [dbo].[Attribute]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Attribute](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[entityid] [dbo].[udtId] NOT NULL,
	[code] [varchar](50) NOT NULL,
	[name] [dbo].[udtName] NOT NULL,
	[columnname] [dbo].[udtSysname] NOT NULL,
	[shortname] [nvarchar](60) NOT NULL,
	[longname] [dbo].[udtName] NOT NULL,
	[datatype] [dbo].[udtSysname] NOT NULL,
	[format] [dbo].[udtCode] NOT NULL,
	[contenttype] [dbo].[udtCode] NOT NULL,
	[sortorder] [dbo].[udtInteger] NOT NULL,
	[justification] [dbo].[udtCode] NOT NULL,
	[usereditable] [dbo].[udtYesNo] NOT NULL,
	[ispersonal] [dbo].[udtYesNo] NOT NULL,
	[ismanagerial] [dbo].[udtYesNo] NOT NULL,
	[tab] [dbo].[udtCode] NULL,
	[dataentry] [dbo].[udtYesNo] NOT NULL,
	[TabBasedSort] [int] NULL,
	[IsPolicyBased] [bit] NOT NULL,
	[Type] [varchar](50) NULL,
	[PermissionAccess] [bit] NOT NULL,
	[ShowOnEntryGroups] [bit] NOT NULL,
	[AttributeSourceID] [int] NULL,
	[FieldValueListID] [int] NULL,
	[IsOrgChartGroupField] [bit] NOT NULL,
	[FunctionHelp] [varchar](max) NULL,
 CONSTRAINT [pkAttribute] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [idxAttributeName] ON [dbo].[Attribute]
(
	[entityid] ASC,
	[columnname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[Attribute] ADD  CONSTRAINT [DF_Attribute_tab]  DEFAULT ((-1)) FOR [tab]
ALTER TABLE [dbo].[Attribute] ADD  CONSTRAINT [DF__Attribute__TabBa__33008CF0]  DEFAULT ((0)) FOR [TabBasedSort]
ALTER TABLE [dbo].[Attribute] ADD  CONSTRAINT [DF_Attribute_IsPolicyBased]  DEFAULT ((0)) FOR [IsPolicyBased]
ALTER TABLE [dbo].[Attribute] ADD  CONSTRAINT [DF_Attribute_PermissionAccess]  DEFAULT ((1)) FOR [PermissionAccess]
ALTER TABLE [dbo].[Attribute] ADD  CONSTRAINT [DF_Attribute_ShowOnEntryGroups]  DEFAULT ((1)) FOR [ShowOnEntryGroups]
ALTER TABLE [dbo].[Attribute] ADD  CONSTRAINT [DF_Attribute_IsOrgChartGroupField_1]  DEFAULT ((0)) FOR [IsOrgChartGroupField]
ALTER TABLE [dbo].[Attribute]  WITH CHECK ADD  CONSTRAINT [FK_Attribute_Entity] FOREIGN KEY([entityid])
REFERENCES [dbo].[Entity] ([id])
ALTER TABLE [dbo].[Attribute] CHECK CONSTRAINT [FK_Attribute_Entity]
