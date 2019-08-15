/****** Object:  Table [dbo].[EmployeeGroupAdmin]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeGroupAdmin](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NOT NULL,
	[employeegroupid] [int] NOT NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_EmployeeGroupAdmin] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeGroupAdmin]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeGroupAdmin_User] FOREIGN KEY([userid])
REFERENCES [dbo].[User] ([id])
ALTER TABLE [dbo].[EmployeeGroupAdmin] CHECK CONSTRAINT [FK_EmployeeGroupAdmin_User]
