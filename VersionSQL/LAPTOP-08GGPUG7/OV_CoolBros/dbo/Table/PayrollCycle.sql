/****** Object:  Table [dbo].[PayrollCycle]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PayrollCycle](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Description] [varchar](max) NULL,
	[PayrollCycleType] [varchar](50) NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[ClosedDate] [datetime] NULL,
	[ClosedByEmpID] [dbo].[udtId] NULL,
	[PayrollStatusID] [int] NOT NULL,
	[isDeleted] [bit] NOT NULL,
	[PayrollCyclePeriodID] [int] NULL,
	[PayrollCycleGroupID] [int] NULL,
	[ExpenseFinalisedDate] [datetime] NULL,
	[ExpenseFinalisedByEmpID] [int] NULL,
	[ExpensePayrollStatusID] [int] NULL,
 CONSTRAINT [PK_PayrollCycle] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[PayrollCycle] ADD  CONSTRAINT [DF_PayrollCycle_PayrollStatusID]  DEFAULT ((1)) FOR [PayrollStatusID]
ALTER TABLE [dbo].[PayrollCycle] ADD  CONSTRAINT [DF_PayrollCycle_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
ALTER TABLE [dbo].[PayrollCycle] ADD  CONSTRAINT [DF_PayrollCycle_ExpensePayrollStatusID]  DEFAULT ((1)) FOR [ExpensePayrollStatusID]
ALTER TABLE [dbo].[PayrollCycle]  WITH CHECK ADD  CONSTRAINT [FK_PayrollCycle_PayrollCycleGroups] FOREIGN KEY([PayrollCycleGroupID])
REFERENCES [dbo].[PayrollCycleGroups] ([ID])
ALTER TABLE [dbo].[PayrollCycle] CHECK CONSTRAINT [FK_PayrollCycle_PayrollCycleGroups]
ALTER TABLE [dbo].[PayrollCycle]  WITH CHECK ADD  CONSTRAINT [FK_PayrollCycle_PayrollCyclePeriods] FOREIGN KEY([PayrollCyclePeriodID])
REFERENCES [dbo].[PayrollCyclePeriods] ([ID])
ALTER TABLE [dbo].[PayrollCycle] CHECK CONSTRAINT [FK_PayrollCycle_PayrollCyclePeriods]
ALTER TABLE [dbo].[PayrollCycle]  WITH CHECK ADD  CONSTRAINT [FK_PayrollCycle_PayrollStatus] FOREIGN KEY([PayrollStatusID])
REFERENCES [dbo].[PayrollStatus] ([ID])
ALTER TABLE [dbo].[PayrollCycle] CHECK CONSTRAINT [FK_PayrollCycle_PayrollStatus]
