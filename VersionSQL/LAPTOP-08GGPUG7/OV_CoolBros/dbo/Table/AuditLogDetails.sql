/****** Object:  Table [dbo].[AuditLogDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AuditLogDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AuditLogID] [int] NOT NULL,
	[AttributeID] [int] NULL,
	[OldValue] [varchar](max) NOT NULL,
	[NewValue] [varchar](max) NOT NULL,
	[Description] [varchar](max) NOT NULL,
 CONSTRAINT [PK_AuditLogDetails] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AuditLogDetails] ADD  CONSTRAINT [DF_AuditLogDetails_Description]  DEFAULT ('') FOR [Description]
ALTER TABLE [dbo].[AuditLogDetails]  WITH CHECK ADD  CONSTRAINT [FK_AuditLogDetails_AuditLog] FOREIGN KEY([AuditLogID])
REFERENCES [dbo].[AuditLog] ([ID])
ALTER TABLE [dbo].[AuditLogDetails] CHECK CONSTRAINT [FK_AuditLogDetails_AuditLog]
