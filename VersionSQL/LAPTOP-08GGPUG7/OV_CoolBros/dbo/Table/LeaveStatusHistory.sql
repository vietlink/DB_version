/****** Object:  Table [dbo].[LeaveStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeaveStatusHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ApproverEmployeeID] [int] NOT NULL,
	[LeaveRequestID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[LeaveStatusID] [int] NOT NULL,
	[Comment] [varchar](max) NULL,
	[State] [int] NOT NULL,
	[SubmittedByID] [int] NULL,
 CONSTRAINT [PK_LeaveStatusHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[LeaveStatusHistory] ADD  CONSTRAINT [DF_LeaveStatusHistory_State]  DEFAULT ((0)) FOR [State]
