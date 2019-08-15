/****** Object:  Table [dbo].[AttributeSource]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AttributeSource](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[IsEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_AttributeSource] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AttributeSource] ADD  CONSTRAINT [DF_AttributeSource_IsEnabled]  DEFAULT ((1)) FOR [IsEnabled]
