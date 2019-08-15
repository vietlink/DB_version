/****** Object:  Table [dbo].[PayrollCycleGroups]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PayrollCycleGroups](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](300) NOT NULL,
	[PayrollCyclePeriodsID] [int] NOT NULL,
	[isDeleted] [bit] NOT NULL,
	[StartDayIndex] [int] NULL,
	[AccountsSystemID] [int] NULL,
 CONSTRAINT [PK_PayrollCycleGroups] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PayrollCycleGroups] ADD  CONSTRAINT [DF_PayrollCycleGroups_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
ALTER TABLE [dbo].[PayrollCycleGroups]  WITH CHECK ADD  CONSTRAINT [FK_PayrollCycleGroups_PayrollCyclePeriods] FOREIGN KEY([PayrollCyclePeriodsID])
REFERENCES [dbo].[PayrollCyclePeriods] ([ID])
ALTER TABLE [dbo].[PayrollCycleGroups] CHECK CONSTRAINT [FK_PayrollCycleGroups_PayrollCyclePeriods]
