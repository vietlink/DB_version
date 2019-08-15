/****** Object:  Table [dbo].[TimesheetBreaks]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimesheetBreaks](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TimesheetHeaderID] [int] NOT NULL,
	[StartTime] [varchar](10) NOT NULL,
	[EndTime] [varchar](10) NULL,
	[Minutes] [decimal](10, 5) NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_TimesheetBreaks] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TimesheetBreaks] ADD  CONSTRAINT [DF_TimesheetBreaks_Minutes]  DEFAULT ((0)) FOR [Minutes]
