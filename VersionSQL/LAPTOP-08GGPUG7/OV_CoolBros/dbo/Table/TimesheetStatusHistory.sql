/****** Object:  Table [dbo].[TimesheetStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimesheetStatusHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ApproverEmployeeID] [int] NOT NULL,
	[TimesheetHeaderID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[TimesheetStatusID] [int] NOT NULL,
	[HasBeenAdjusted] [bit] NOT NULL,
 CONSTRAINT [PK_TimesheetStatusHistoryID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TimesheetStatusHistory] ADD  CONSTRAINT [DF_TimesheetStatusHistory_HasBeenAdjusted]  DEFAULT ((0)) FOR [HasBeenAdjusted]
ALTER TABLE [dbo].[TimesheetStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetStatusHistoryID_TimesheetHeader] FOREIGN KEY([TimesheetHeaderID])
REFERENCES [dbo].[TimesheetHeader] ([ID])
ALTER TABLE [dbo].[TimesheetStatusHistory] CHECK CONSTRAINT [FK_TimesheetStatusHistoryID_TimesheetHeader]
ALTER TABLE [dbo].[TimesheetStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetStatusHistoryID_TimesheetStatus] FOREIGN KEY([TimesheetStatusID])
REFERENCES [dbo].[TimesheetStatus] ([ID])
ALTER TABLE [dbo].[TimesheetStatusHistory] CHECK CONSTRAINT [FK_TimesheetStatusHistoryID_TimesheetStatus]
