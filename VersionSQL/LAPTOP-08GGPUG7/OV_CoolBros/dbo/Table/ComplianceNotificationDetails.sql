/****** Object:  Table [dbo].[ComplianceNotificationDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ComplianceNotificationDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmailTo] [varchar](2000) NOT NULL,
	[EmailDue] [bit] NOT NULL,
	[EmailExpired] [bit] NOT NULL,
	[EmailAfter] [bit] NOT NULL,
	[EmailAfterDays] [int] NULL,
	[CheckNotificationDays] [int] NOT NULL,
	[DueDays] [int] NOT NULL,
	[HeaderExpired] [varchar](2000) NOT NULL,
	[HeaderDue] [varchar](2000) NOT NULL,
	[HeaderExpireAfter] [varchar](2000) NOT NULL,
	[HeaderEmpExpired] [varchar](2000) NOT NULL,
	[HeaderEmpDue] [varchar](2000) NOT NULL,
	[HeaderEmpExpireAfter] [varchar](2000) NOT NULL,
	[EmailEmployeeExpired] [bit] NOT NULL,
	[EmailEmployeeDue] [bit] NOT NULL,
	[EmailEmployeeExpireAfter] [bit] NOT NULL,
 CONSTRAINT [PK_ComplianceNotificationDetails] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ComplianceNotificationDetails] ADD  CONSTRAINT [DF_ComplianceNotificationDetails_CheckNotificationDays]  DEFAULT ((1)) FOR [CheckNotificationDays]
ALTER TABLE [dbo].[ComplianceNotificationDetails] ADD  CONSTRAINT [DF_ComplianceNotificationDetails_DueDays]  DEFAULT ((0)) FOR [DueDays]
ALTER TABLE [dbo].[ComplianceNotificationDetails] ADD  CONSTRAINT [DF_ComplianceNotificationDetails_Header]  DEFAULT ('') FOR [HeaderExpired]
ALTER TABLE [dbo].[ComplianceNotificationDetails] ADD  CONSTRAINT [DF_ComplianceNotificationDetails_HeaderDue]  DEFAULT ('') FOR [HeaderDue]
ALTER TABLE [dbo].[ComplianceNotificationDetails] ADD  CONSTRAINT [DF_ComplianceNotificationDetails_HeaderExpire]  DEFAULT ('') FOR [HeaderExpireAfter]
ALTER TABLE [dbo].[ComplianceNotificationDetails] ADD  CONSTRAINT [DF_ComplianceNotificationDetails_HeaderEmpExpired]  DEFAULT ('') FOR [HeaderEmpExpired]
ALTER TABLE [dbo].[ComplianceNotificationDetails] ADD  CONSTRAINT [DF_ComplianceNotificationDetails_HeaderEmpDue]  DEFAULT ('') FOR [HeaderEmpDue]
ALTER TABLE [dbo].[ComplianceNotificationDetails] ADD  CONSTRAINT [DF_ComplianceNotificationDetails_HeaderEmpExpireAfter]  DEFAULT ('') FOR [HeaderEmpExpireAfter]
ALTER TABLE [dbo].[ComplianceNotificationDetails] ADD  CONSTRAINT [DF_ComplianceNotificationDetails_EmailEmployeeDue]  DEFAULT ((0)) FOR [EmailEmployeeDue]
ALTER TABLE [dbo].[ComplianceNotificationDetails] ADD  CONSTRAINT [DF_ComplianceNotificationDetails_EmailEmployeeExpireAfter]  DEFAULT ((0)) FOR [EmailEmployeeExpireAfter]
