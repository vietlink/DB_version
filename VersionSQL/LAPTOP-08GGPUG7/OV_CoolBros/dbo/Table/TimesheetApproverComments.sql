/****** Object:  Table [dbo].[TimesheetApproverComments]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimesheetApproverComments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateAdded] [datetime] NOT NULL,
	[Comment] [varchar](max) NOT NULL,
	[TimesheetHeaderID] [int] NOT NULL,
	[DisplayName] [varchar](255) NOT NULL,
	[RejectedComment] [bit] NOT NULL,
 CONSTRAINT [PK_TimesheetApproverComments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TimesheetApproverComments] ADD  CONSTRAINT [DF_TimesheetApproverComments_DisplayName]  DEFAULT ('') FOR [DisplayName]
ALTER TABLE [dbo].[TimesheetApproverComments] ADD  CONSTRAINT [DF_TimesheetApproverComments_RejectComment]  DEFAULT ((0)) FOR [RejectedComment]
