/****** Object:  Table [dbo].[TimesheetHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimesheetHeader](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[PayrollCycleID] [int] NOT NULL,
	[TimesheetStatusID] [int] NOT NULL,
	[ApproverComments] [varchar](max) NULL,
	[LastUpdated] [datetime] NULL,
	[CreatedBy] [varchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[ContractedHours] [decimal](10, 5) NULL,
	[WorkedHours] [decimal](10, 5) NULL,
	[LeaveHours] [decimal](10, 5) NULL,
	[TotalHours] [decimal](10, 5) NULL,
	[OvertimeHours] [decimal](10, 5) NULL,
	[ToilHours] [decimal](10, 5) NULL,
	[CostCentreID] [int] NULL,
	[IsLocked] [bit] NOT NULL,
	[IsTimesheetApproved] [bit] NOT NULL,
	[IsAdditionalApproved] [bit] NOT NULL,
	[RequiresAdditionalApproval] [bit] NOT NULL,
	[ProcessedPayCycleID] [int] NULL,
 CONSTRAINT [PK_TimesheetHeader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TimesheetHeader] ADD  CONSTRAINT [DF_TimesheetHeader_IsLocked]  DEFAULT ((0)) FOR [IsLocked]
ALTER TABLE [dbo].[TimesheetHeader] ADD  CONSTRAINT [DF_TimesheetHeader_IsTimesheetApproved]  DEFAULT ((0)) FOR [IsTimesheetApproved]
ALTER TABLE [dbo].[TimesheetHeader] ADD  CONSTRAINT [DF_TimesheetHeader_IsAdditionalApproved]  DEFAULT ((0)) FOR [IsAdditionalApproved]
ALTER TABLE [dbo].[TimesheetHeader] ADD  CONSTRAINT [DF_TimesheetHeader_RequiresAdditionalApproval]  DEFAULT ((0)) FOR [RequiresAdditionalApproval]
ALTER TABLE [dbo].[TimesheetHeader]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetHeader_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([id])
ALTER TABLE [dbo].[TimesheetHeader] CHECK CONSTRAINT [FK_TimesheetHeader_Employee]
ALTER TABLE [dbo].[TimesheetHeader]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetHeader_TimesheetHeader1] FOREIGN KEY([ID])
REFERENCES [dbo].[TimesheetHeader] ([ID])
ALTER TABLE [dbo].[TimesheetHeader] CHECK CONSTRAINT [FK_TimesheetHeader_TimesheetHeader1]
ALTER TABLE [dbo].[TimesheetHeader]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetHeader_TimesheetStatus] FOREIGN KEY([TimesheetStatusID])
REFERENCES [dbo].[TimesheetStatus] ([ID])
ALTER TABLE [dbo].[TimesheetHeader] CHECK CONSTRAINT [FK_TimesheetHeader_TimesheetStatus]
