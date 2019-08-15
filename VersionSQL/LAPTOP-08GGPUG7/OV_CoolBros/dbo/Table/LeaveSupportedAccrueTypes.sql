/****** Object:  Table [dbo].[LeaveSupportedAccrueTypes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeaveSupportedAccrueTypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LeaveTypeID] [int] NOT NULL,
	[SupportedLeaveTypeID] [int] NOT NULL,
	[AccrueLeave] [bit] NOT NULL,
 CONSTRAINT [PK_LeaveSupportedAccrueTypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LeaveSupportedAccrueTypes] ADD  CONSTRAINT [DF_LeaveSupportedAccrueTypes_AccrueLeave]  DEFAULT ((0)) FOR [AccrueLeave]
