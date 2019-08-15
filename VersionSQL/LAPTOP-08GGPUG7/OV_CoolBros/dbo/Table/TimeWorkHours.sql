/****** Object:  Table [dbo].[TimeWorkHours]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimeWorkHours](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DayCode] [varchar](20) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[NormalHours] [decimal](10, 5) NULL,
	[ExtraHours] [decimal](10, 5) NULL,
	[TotalContractedHours] [decimal](10, 5) NULL,
	[StartTime] [varchar](8) NULL,
	[EndTime] [varchar](8) NULL,
	[BreakMinutes] [decimal](10, 5) NULL,
	[TimeWorkHoursHeaderID] [int] NOT NULL,
	[Week] [int] NOT NULL,
	[OvertimeStartsAfter] [decimal](10, 5) NULL,
 CONSTRAINT [PK_TimeWorkHours] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TimeWorkHours] ADD  CONSTRAINT [DF_TimeWorkHours_Enabled]  DEFAULT ((0)) FOR [Enabled]
ALTER TABLE [dbo].[TimeWorkHours] ADD  CONSTRAINT [DF_TimeWorkHours_Week]  DEFAULT ((1)) FOR [Week]
ALTER TABLE [dbo].[TimeWorkHours]  WITH CHECK ADD  CONSTRAINT [FK_TimeWorkHours_TimeWorkHoursHeader] FOREIGN KEY([TimeWorkHoursHeaderID])
REFERENCES [dbo].[TimeWorkHoursHeader] ([ID])
ALTER TABLE [dbo].[TimeWorkHours] CHECK CONSTRAINT [FK_TimeWorkHours_TimeWorkHoursHeader]
