/****** Object:  Table [dbo].[LeaveRequest]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeaveRequest](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[LeaveTypeID] [int] NOT NULL,
	[LeaveStatusID] [int] NOT NULL,
	[ReasonForLeave] [varchar](1000) NULL,
	[LeaveContactDetails] [varchar](1000) NULL,
	[ApproverComments] [varchar](1000) NULL,
	[TimePeriodRequested] [decimal](18, 8) NOT NULL,
	[DateFrom] [datetime] NOT NULL,
	[DateTo] [datetime] NOT NULL,
	[ExclWeekends] [bit] NOT NULL,
	[ExclPublicHolidays] [bit] NOT NULL,
	[Period] [varchar](20) NULL,
	[PeriodFrom] [varchar](20) NULL,
	[PeriodTo] [varchar](20) NULL,
	[ExclAlreadyRequested] [bit] NOT NULL,
	[EmployeeWorkHoursHeaderID] [int] NULL,
	[Approved1] [bit] NOT NULL,
	[Approved2] [bit] NOT NULL,
	[ApprovedNegative] [bit] NOT NULL,
	[Approver1EPID] [int] NULL,
	[Approver2EPID] [int] NULL,
	[Approver3EPID] [int] NULL,
	[IsCancelled] [bit] NOT NULL,
	[IsPayCycleLocked] [bit] NOT NULL,
	[DocumentID] [int] NULL,
	[IsAutoApproved] [bit] NULL,
 CONSTRAINT [PK_LeaveRequest] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LeaveRequest] ADD  CONSTRAINT [DF_LeaveRequest_ExclWeekends]  DEFAULT ((0)) FOR [ExclWeekends]
ALTER TABLE [dbo].[LeaveRequest] ADD  CONSTRAINT [DF_LeaveRequest_ExclPublicHolidays]  DEFAULT ((0)) FOR [ExclPublicHolidays]
ALTER TABLE [dbo].[LeaveRequest] ADD  CONSTRAINT [DF_LeaveRequest_ExclAlreadyRequested]  DEFAULT ((1)) FOR [ExclAlreadyRequested]
ALTER TABLE [dbo].[LeaveRequest] ADD  CONSTRAINT [DF_LeaveRequest_Approved1]  DEFAULT ((0)) FOR [Approved1]
ALTER TABLE [dbo].[LeaveRequest] ADD  CONSTRAINT [DF_LeaveRequest_Approved2]  DEFAULT ((0)) FOR [Approved2]
ALTER TABLE [dbo].[LeaveRequest] ADD  CONSTRAINT [DF_LeaveRequest_ApprovedNegative]  DEFAULT ((0)) FOR [ApprovedNegative]
ALTER TABLE [dbo].[LeaveRequest] ADD  CONSTRAINT [DF_LeaveRequest_IsCancelled]  DEFAULT ((0)) FOR [IsCancelled]
ALTER TABLE [dbo].[LeaveRequest] ADD  CONSTRAINT [DF_LeaveRequest_IsCycleLocked]  DEFAULT ((0)) FOR [IsPayCycleLocked]
ALTER TABLE [dbo].[LeaveRequest] ADD  CONSTRAINT [DF_LeaveRequest_IsAutoApproved]  DEFAULT ((0)) FOR [IsAutoApproved]
