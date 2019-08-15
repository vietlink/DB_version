/****** Object:  Table [dbo].[EmployeeWorkHours]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeWorkHours](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[DayCode] [varchar](20) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[StartDateTime] [datetime] NOT NULL,
	[EndDateTime] [datetime] NOT NULL,
	[WorkHours] [decimal](18, 2) NOT NULL,
	[EmployeeWorkHoursHeaderID] [int] NULL,
	[Week] [int] NOT NULL,
	[DayCodeShort] [varchar](20) NULL,
	[ExtraHours] [decimal](10, 5) NULL,
	[StartTime] [varchar](8) NULL,
	[EndTime] [varchar](8) NULL,
	[BreakMinutes] [decimal](10, 5) NULL,
	[OvertimeStartsAfter] [decimal](10, 5) NULL,
 CONSTRAINT [PK_EmployeeWorkHours] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeWorkHours] ADD  CONSTRAINT [DF_EmployeeWorkHours_Enabled]  DEFAULT ((0)) FOR [Enabled]
ALTER TABLE [dbo].[EmployeeWorkHours] ADD  CONSTRAINT [DF_EmployeeWorkHours_Week]  DEFAULT ((1)) FOR [Week]
