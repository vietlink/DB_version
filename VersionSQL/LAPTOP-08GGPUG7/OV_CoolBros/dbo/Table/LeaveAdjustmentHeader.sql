/****** Object:  Table [dbo].[LeaveAdjustmentHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeaveAdjustmentHeader](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[LeaveTypeID] [int] NOT NULL,
	[CreditAmount] [decimal](25, 15) NULL,
	[DebitAmount] [decimal](25, 15) NULL,
	[Reason] [varchar](max) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[isPayout] [bit] NOT NULL,
 CONSTRAINT [PK_LeaveAdjustmentHeader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[LeaveAdjustmentHeader] ADD  CONSTRAINT [DF_LeaveAdjustmentHeader_isPayout]  DEFAULT ((0)) FOR [isPayout]
