/****** Object:  Table [dbo].[AuditLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AuditLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[PositionID] [int] NOT NULL,
	[DataID] [int] NULL,
	[CreatedBy] [varchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[AuditLogTypeID] [int] NOT NULL,
	[ItemDesc] [varchar](255) NULL,
 CONSTRAINT [PK_AuditLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AuditLog]  WITH CHECK ADD  CONSTRAINT [FK_AuditLog_AuditLogType] FOREIGN KEY([AuditLogTypeID])
REFERENCES [dbo].[AuditLogType] ([ID])
ALTER TABLE [dbo].[AuditLog] CHECK CONSTRAINT [FK_AuditLog_AuditLogType]
