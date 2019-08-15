/****** Object:  Table [dbo].[TimeWorkProfileTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimeWorkProfileTemplate](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShortDescription] [varchar](100) NOT NULL,
	[Description] [varchar](255) NULL,
	[Code] [varchar](20) NULL,
	[PayRollCycle] [int] NOT NULL,
	[EnableTimesheet] [bit] NOT NULL,
	[EnableProjectTimesheet] [bit] NOT NULL,
	[EnableSwipeCard] [bit] NOT NULL,
	[TimesheetTimeMode] [int] NOT NULL,
	[ProjectTimeMode] [int] NOT NULL,
	[DefaultProjectID] [int] NULL,
	[DefaultTaskID] [int] NULL,
	[TimeWorkHoursHeaderID] [int] NOT NULL,
	[TimeShiftLoadingHeaderID] [int] NOT NULL,
	[AllowOvertime] [bit] NOT NULL,
	[NormalOvertimeRate] [decimal](10, 5) NULL,
	[OvertimeStartsAfter] [decimal](10, 5) NULL,
	[DefaultOvertimeTo] [int] NOT NULL,
	[ApplyOvertimeOption] [int] NOT NULL,
 CONSTRAINT [PK_TimeWorkProfileTemplate] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TimeWorkProfileTemplate] ADD  CONSTRAINT [DF_TimeWorkProfileTemplate_EnableTimesheet]  DEFAULT ((1)) FOR [EnableTimesheet]
ALTER TABLE [dbo].[TimeWorkProfileTemplate] ADD  CONSTRAINT [DF_TimeWorkProfileTemplate_EnableProjectTimesheet]  DEFAULT ((0)) FOR [EnableProjectTimesheet]
ALTER TABLE [dbo].[TimeWorkProfileTemplate] ADD  CONSTRAINT [DF_TimeWorkProfileTemplate_TimesheetTimeMode]  DEFAULT ((0)) FOR [TimesheetTimeMode]
ALTER TABLE [dbo].[TimeWorkProfileTemplate] ADD  CONSTRAINT [DF_TimeWorkProfileTemplate_ProjectTimeMode]  DEFAULT ((0)) FOR [ProjectTimeMode]
ALTER TABLE [dbo].[TimeWorkProfileTemplate] ADD  CONSTRAINT [DF_Table_1_WorkHourPattern]  DEFAULT ((0)) FOR [TimeWorkHoursHeaderID]
ALTER TABLE [dbo].[TimeWorkProfileTemplate] ADD  CONSTRAINT [DF_TimeWorkProfileTemplate_AllowOvertime]  DEFAULT ((1)) FOR [AllowOvertime]
ALTER TABLE [dbo].[TimeWorkProfileTemplate] ADD  CONSTRAINT [DF_TimeWorkProfileTemplate_DefaultOvertimeTo]  DEFAULT ((0)) FOR [DefaultOvertimeTo]
ALTER TABLE [dbo].[TimeWorkProfileTemplate] ADD  CONSTRAINT [DF_TimeWorkProfileTemplate_ApplyOvertime]  DEFAULT ((0)) FOR [ApplyOvertimeOption]
