/****** Object:  Table [dbo].[TimesheetDay]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimesheetDay](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TimesheetHeaderID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[StartTime] [varchar](10) NOT NULL,
	[FinishTime] [varchar](10) NOT NULL,
	[Breaks] [decimal](10, 5) NOT NULL,
	[Hours] [decimal](10, 5) NOT NULL,
	[HasChanged] [bit] NOT NULL,
 CONSTRAINT [PK_TimesheetDay] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TimesheetDay] ADD  CONSTRAINT [DF_TimesheetDay_HasChanged]  DEFAULT ((0)) FOR [HasChanged]
ALTER TABLE [dbo].[TimesheetDay]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetDay_TimesheetDay] FOREIGN KEY([ID])
REFERENCES [dbo].[TimesheetDay] ([ID])
ALTER TABLE [dbo].[TimesheetDay] CHECK CONSTRAINT [FK_TimesheetDay_TimesheetDay]
ALTER TABLE [dbo].[TimesheetDay]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetDay_TimesheetDay1] FOREIGN KEY([TimesheetHeaderID])
REFERENCES [dbo].[TimesheetHeader] ([ID])
ALTER TABLE [dbo].[TimesheetDay] CHECK CONSTRAINT [FK_TimesheetDay_TimesheetDay1]
