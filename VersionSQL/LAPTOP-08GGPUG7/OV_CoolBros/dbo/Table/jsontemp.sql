/****** Object:  Table [dbo].[jsontemp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[jsontemp](
	[element_id] [int] NULL,
	[sequenceNo] [int] NULL,
	[parent_ID] [int] NULL,
	[Object_ID] [int] NULL,
	[NAME] [varchar](max) NULL,
	[StringValue] [varchar](max) NULL,
	[ValueType] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

