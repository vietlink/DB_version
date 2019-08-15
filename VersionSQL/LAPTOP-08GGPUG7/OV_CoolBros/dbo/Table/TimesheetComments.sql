/****** Object:  Table [dbo].[TimesheetComments]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimesheetComments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateFor] [datetime] NOT NULL,
	[DateAdded] [datetime] NOT NULL,
	[Comment] [varchar](max) NOT NULL,
	[DisplayName] [varchar](255) NOT NULL,
	[TimesheetHeaderID] [int] NOT NULL,
	[Week] [int] NOT NULL,
 CONSTRAINT [PK_TimesheetComments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

