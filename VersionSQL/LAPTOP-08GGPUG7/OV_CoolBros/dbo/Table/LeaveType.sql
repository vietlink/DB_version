/****** Object:  Table [dbo].[LeaveType]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeaveType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[BackgroundColour] [varchar](25) NULL,
	[FontColour] [varchar](25) NULL,
	[AccrueLeave] [bit] NOT NULL,
	[LeavePerYear] [decimal](10, 5) NOT NULL,
	[SystemCode] [varchar](50) NOT NULL,
	[AccruePeriod] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[PaidLeave] [bit] NULL,
	[PlannedLeave] [bit] NULL,
	[DefaultNewPeople] [bit] NULL,
	[AccrueInAdvanced] [bit] NULL,
	[AccrueAfterDays] [int] NULL,
	[ZeroBalanceMonth] [int] NULL,
	[ZeroBalanceDay] [int] NULL,
	[LeaveExpireDays] [int] NULL,
	[LeaveBookableOptions] [int] NULL,
	[CanApplyAfterDays] [int] NULL,
	[GoodMin] [decimal](10, 5) NULL,
	[GoodMax] [decimal](10, 5) NULL,
	[MonitorMin] [decimal](10, 5) NULL,
	[MonitorMax] [decimal](10, 5) NULL,
	[ActionMin] [decimal](10, 5) NULL,
	[ActionMax] [decimal](10, 5) NULL,
	[GoodBackgroundColour] [varchar](25) NULL,
	[GoodTextColour] [varchar](25) NULL,
	[MonitorBackgroundColour] [varchar](25) NULL,
	[MonitorTextColour] [varchar](25) NULL,
	[ActionBackgroundColour] [varchar](25) NULL,
	[ActionTextColour] [varchar](25) NULL,
	[SickTolleranceStartDays] [int] NULL,
	[AllowDocuments] [bit] NULL,
	[ZeroBalanceEnabled] [bit] NULL,
	[EmailUpdates] [bit] NULL,
	[Approver1] [int] NULL,
	[Approver2] [int] NULL,
	[Escalate1ID] [int] NULL,
	[Escalate2ID] [int] NULL,
	[ApprovalLevel] [int] NULL,
	[EmailApprover] [bit] NULL,
	[EmailReminderDays1] [int] NULL,
	[EmailText] [varchar](max) NULL,
	[AllowNegative] [bit] NOT NULL,
	[NegativeTolerance] [decimal](10, 5) NOT NULL,
	[LeaveClassify] [int] NOT NULL,
	[ReportDescription] [varchar](100) NULL,
	[MaxAccruedBalance] [decimal](10, 5) NULL,
	[MinimumLeave] [decimal](10, 5) NULL,
	[Approver3] [int] NULL,
	[Escalate3ID] [int] NULL,
	[RequiresCancelApproval] [bit] NOT NULL,
	[OverridePositionLevel] [bit] NOT NULL,
	[PaidOnTermination] [bit] NOT NULL,
	[ReasonRequired] [bit] NOT NULL,
	[MaximumLeave] [decimal](10, 5) NOT NULL,
	[CommencementShowDays] [decimal](10, 5) NOT NULL,
	[EmailBackText] [varchar](max) NULL,
 CONSTRAINT [PK_LeaveType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_AccrueLeave]  DEFAULT ((0)) FOR [AccrueLeave]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_LeavePerYear]  DEFAULT ((0)) FOR [LeavePerYear]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_SystemCode]  DEFAULT ('') FOR [SystemCode]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_AccruePeriod]  DEFAULT ((1)) FOR [AccruePeriod]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_Enabled]  DEFAULT ((1)) FOR [Enabled]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_AllowNegative]  DEFAULT ((0)) FOR [AllowNegative]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_NegativeTolerance]  DEFAULT ((0)) FOR [NegativeTolerance]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_LeaveClassify]  DEFAULT ((0)) FOR [LeaveClassify]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_MaxAccruedBalance]  DEFAULT ((0.0)) FOR [MaxAccruedBalance]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_Approver3]  DEFAULT ((0)) FOR [Approver3]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_RequiresCancelApproval]  DEFAULT ((0)) FOR [RequiresCancelApproval]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_OverridePositionLevel]  DEFAULT ((0)) FOR [OverridePositionLevel]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_PaidOnTermination]  DEFAULT ((0)) FOR [PaidOnTermination]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_ReasonRequired]  DEFAULT ((0)) FOR [ReasonRequired]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_MaximumLeave]  DEFAULT ((0)) FOR [MaximumLeave]
ALTER TABLE [dbo].[LeaveType] ADD  CONSTRAINT [DF_LeaveType_CommencementShowDays]  DEFAULT ((0)) FOR [CommencementShowDays]
