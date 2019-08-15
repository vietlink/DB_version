/****** Object:  Table [dbo].[EventLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EventLog](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[type] [dbo].[udtEventLogType] NOT NULL,
	[source] [dbo].[udtName50] NOT NULL,
	[message] [dbo].[udtSetting] NOT NULL,
	[createuser] [dbo].[udtName50] NOT NULL,
	[createdatetime] [dbo].[udtDate] NOT NULL,
	[DataFileID] [int] NULL,
	[RowNumber] [int] NULL,
	[Action] [varchar](50) NULL,
 CONSTRAINT [pkEventLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EventLog]  WITH NOCHECK ADD  CONSTRAINT [ckEventLogType] CHECK  (([type]=(16) OR ([type]=(8) OR ([type]=(4) OR ([type]=(2) OR [type]=(1))))))
ALTER TABLE [dbo].[EventLog] CHECK CONSTRAINT [ckEventLogType]
