/****** Object:  Table [dbo].[AttributeModules]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AttributeModules](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleName] [varchar](100) NOT NULL,
	[SectionName] [varchar](50) NULL,
	[PageURL] [varchar](200) NOT NULL,
	[Ordering] [int] NOT NULL,
	[AttributeID] [int] NOT NULL,
	[GroupType] [varchar](100) NOT NULL,
	[GroupHeader] [varchar](max) NULL,
 CONSTRAINT [PK_AttributeModules] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AttributeModules] ADD  CONSTRAINT [DF_AttributeModules_GroupType]  DEFAULT ('') FOR [GroupType]
