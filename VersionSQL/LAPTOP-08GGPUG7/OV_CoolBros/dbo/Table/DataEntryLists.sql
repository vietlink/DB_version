/****** Object:  Table [dbo].[DataEntryLists]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DataEntryLists](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[listid] [dbo].[udtId] NOT NULL,
	[description] [dbo].[udtName] NOT NULL,
	[sortorder] [dbo].[udtId] NULL
) ON [PRIMARY]

