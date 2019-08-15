/****** Object:  Table [dbo].[TimesheetSettings]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimesheetSettings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Approver1] [int] NULL,
	[Approver1PositionID] [int] NULL,
	[SendTSOverdueEmailFlag] [bit] NULL,
	[SendTSOverdueEmailText] [varchar](max) NULL,
	[SendTSApproverEmailFlag] [bit] NULL,
	[SendTSApproverEmailText] [varchar](max) NULL,
	[SendTSEmailRejectFlag] [bit] NULL,
	[SendTSEmailRejectText] [varchar](max) NULL,
	[SendTSEmailApproveFlag] [bit] NULL,
	[SendTSEmailApproveText] [varchar](max) NULL,
	[TOILApprover1] [int] NULL,
	[TOILApprover1PositionID] [int] NULL,
	[SendTOILApproverEmailFlag] [bit] NULL,
	[SendTOILApproverEmailText] [varchar](max) NULL,
	[SendTOILEmailApproveFlag] [bit] NULL,
	[SendTOILEmailApproveText] [varchar](max) NULL,
	[SendTOILEmailRejectFlag] [bit] NULL,
	[SendTOILEmailRejectText] [varchar](max) NULL,
	[CanTimesheetApproverAdjust] [bit] NULL,
 CONSTRAINT [PK_TimesheetSettings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TimesheetSettings] ADD  CONSTRAINT [DF_TimesheetSettings_CanTimesheetApproverAdjust]  DEFAULT ((0)) FOR [CanTimesheetApproverAdjust]
