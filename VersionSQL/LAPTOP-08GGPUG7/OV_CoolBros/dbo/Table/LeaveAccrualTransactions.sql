/****** Object:  Table [dbo].[LeaveAccrualTransactions]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeaveAccrualTransactions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[LeaveTypeID] [int] NOT NULL,
	[DateFrom] [datetime] NOT NULL,
	[DateTo] [datetime] NOT NULL,
	[TransactionTypeID] [int] NOT NULL,
	[Balance] [decimal](25, 15) NULL,
	[Taken] [decimal](25, 15) NULL,
	[Adjustment] [decimal](25, 15) NULL,
	[Comment] [varchar](max) NULL,
	[Mode] [varchar](255) NULL,
	[LeaveRequestID] [int] NULL,
	[LeaveAdjustmentHeaderID] [int] NULL,
	[PayrollCycleID] [int] NOT NULL,
	[LeaveEntitlement] [decimal](25, 15) NULL,
 CONSTRAINT [PK_LeaveAccrualTransactions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[LeaveAccrualTransactions] ADD  CONSTRAINT [DF_LeaveAccrualTransactions_PayrollCycleID]  DEFAULT ((0)) FOR [PayrollCycleID]
