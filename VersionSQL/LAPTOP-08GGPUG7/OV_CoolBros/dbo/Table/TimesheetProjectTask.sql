/****** Object:  Table [dbo].[TimesheetProjectTask]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimesheetProjectTask](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TimesheetHeaderID] [int] NOT NULL,
	[StartTime] [varchar](10) NOT NULL,
	[FinishTime] [varchar](10) NOT NULL,
 CONSTRAINT [PK_TimesheetProjectTask] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TimesheetProjectTask]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetProjectTask_TimesheetHeader] FOREIGN KEY([TimesheetHeaderID])
REFERENCES [dbo].[TimesheetHeader] ([ID])
ALTER TABLE [dbo].[TimesheetProjectTask] CHECK CONSTRAINT [FK_TimesheetProjectTask_TimesheetHeader]
