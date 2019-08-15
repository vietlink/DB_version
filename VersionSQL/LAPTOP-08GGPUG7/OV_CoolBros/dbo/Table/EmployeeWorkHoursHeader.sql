/****** Object:  Table [dbo].[EmployeeWorkHoursHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeWorkHoursHeader](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[DateFrom] [datetime] NOT NULL,
	[DateTo] [datetime] NULL,
	[HolidayRegionID] [int] NULL,
	[SalaryBase] [decimal](18, 2) NOT NULL,
	[WeekMode] [int] NOT NULL,
	[PayRollCycle] [int] NOT NULL,
	[EnableTimesheet] [bit] NOT NULL,
	[EnableProjectTimesheet] [bit] NOT NULL,
	[EnableSwipeCard] [bit] NOT NULL,
	[TimesheetTimeMode] [int] NOT NULL,
	[ProjectTimeMode] [int] NOT NULL,
	[DefaultRecordingMethod] [int] NOT NULL,
	[AllowAutoApproval] [bit] NOT NULL,
	[DefaultProjectID] [int] NULL,
	[DefaultTaskID] [int] NULL,
	[TimeShiftLoadingHeaderID] [int] NULL,
	[AllowOvertime] [bit] NOT NULL,
	[NormalOvertimeRate] [int] NULL,
	[OvertimeStartsAfter] [decimal](10, 5) NULL,
	[DefaultOvertimeTo] [int] NOT NULL,
	[ApplyOvertimeOption] [int] NOT NULL,
	[StartBuffer] [decimal](10, 5) NULL,
	[FinishBuffer] [decimal](10, 5) NULL,
	[MaxToilBalance] [decimal](10, 5) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsReturningEmployee] [bit] NOT NULL,
	[ExtraHoursPayType] [int] NOT NULL,
	[NoApprovalForLeave] [bit] NOT NULL,
	[NoApprovalForTimesheet] [bit] NOT NULL,
	[NoApprovalForExpense] [bit] NOT NULL,
	[PayCostCentreID] [int] NULL,
	[ExpenseCostCentreID] [int] NULL,
	[ModuleTimesheet] [bit] NOT NULL,
	[ModuleLeave] [bit] NOT NULL,
	[ModuleExpense] [bit] NOT NULL,
	[CapHours] [bit] NOT NULL,
 CONSTRAINT [PK_EmployeeWorkHoursHeader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_WeekMode]  DEFAULT ((1)) FOR [WeekMode]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_PayRollCycle]  DEFAULT ((0)) FOR [PayRollCycle]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_EnableTimesheet]  DEFAULT ((0)) FOR [EnableTimesheet]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_EnableProjectTimesheet]  DEFAULT ((0)) FOR [EnableProjectTimesheet]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_EnableSwipeCard]  DEFAULT ((0)) FOR [EnableSwipeCard]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_TimesheetTimeMode]  DEFAULT ((0)) FOR [TimesheetTimeMode]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_ProjectTimeMode]  DEFAULT ((0)) FOR [ProjectTimeMode]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_DefaultRecordingMethod]  DEFAULT ((0)) FOR [DefaultRecordingMethod]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_AllowAutoApproval]  DEFAULT ((0)) FOR [AllowAutoApproval]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_TimeShiftLoadingHeaderID]  DEFAULT ((0)) FOR [TimeShiftLoadingHeaderID]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_AllowOvertime]  DEFAULT ((0)) FOR [AllowOvertime]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_NormalOvertimeRate]  DEFAULT ((0)) FOR [NormalOvertimeRate]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_DefaultOvertimeTo]  DEFAULT ((0)) FOR [DefaultOvertimeTo]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_ApplyOvertimeOption]  DEFAULT ((0)) FOR [ApplyOvertimeOption]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_ReturningEmployee]  DEFAULT ((0)) FOR [IsReturningEmployee]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_ExtraHoursPayType]  DEFAULT ((1)) FOR [ExtraHoursPayType]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_chkNoApprovalForLeave]  DEFAULT ((0)) FOR [NoApprovalForLeave]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_NoApprovalForTimesheet]  DEFAULT ((0)) FOR [NoApprovalForTimesheet]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_NoApprovalForExpense]  DEFAULT ((0)) FOR [NoApprovalForExpense]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_ModuleTimesheet]  DEFAULT ((1)) FOR [ModuleTimesheet]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_ModuleLeave]  DEFAULT ((1)) FOR [ModuleLeave]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_ModuleExpense]  DEFAULT ((1)) FOR [ModuleExpense]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] ADD  CONSTRAINT [DF_EmployeeWorkHoursHeader_CapHours]  DEFAULT ((1)) FOR [CapHours]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader]  WITH NOCHECK ADD  CONSTRAINT [FK_EmployeeWorkHoursHeader_HolidayRegion] FOREIGN KEY([HolidayRegionID])
REFERENCES [dbo].[HolidayRegion] ([ID])
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] CHECK CONSTRAINT [FK_EmployeeWorkHoursHeader_HolidayRegion]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader]  WITH NOCHECK ADD  CONSTRAINT [FK_EmployeeWorkHoursHeader_Tasks] FOREIGN KEY([DefaultTaskID])
REFERENCES [dbo].[Tasks] ([ID])
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] CHECK CONSTRAINT [FK_EmployeeWorkHoursHeader_Tasks]
ALTER TABLE [dbo].[EmployeeWorkHoursHeader]  WITH NOCHECK ADD  CONSTRAINT [FK_EmployeeWorkHoursHeader_TimeShiftLoadingHeader] FOREIGN KEY([TimeShiftLoadingHeaderID])
REFERENCES [dbo].[TimeShiftLoadingHeader] ([ID])
ALTER TABLE [dbo].[EmployeeWorkHoursHeader] CHECK CONSTRAINT [FK_EmployeeWorkHoursHeader_TimeShiftLoadingHeader]
