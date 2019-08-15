/****** Object:  Table [dbo].[LeaveRequestDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeaveRequestDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LeaveRequestID] [int] NOT NULL,
	[LeaveDateFrom] [datetime] NOT NULL,
	[LeaveDateTo] [datetime] NOT NULL,
	[Duration] [decimal](18, 2) NOT NULL,
	[EmployeeWorkHoursHeaderID] [int] NULL,
	[PayrollCycleID] [int] NOT NULL,
 CONSTRAINT [PK_LeaveRequestDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LeaveRequestDetail] ADD  CONSTRAINT [DF_LeaveRequestDetail_PayrollCycleID]  DEFAULT ((0)) FOR [PayrollCycleID]
