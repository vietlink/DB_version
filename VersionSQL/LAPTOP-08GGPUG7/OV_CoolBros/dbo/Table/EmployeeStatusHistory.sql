/****** Object:  Table [dbo].[EmployeeStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeStatusHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[TerminationReason] [varchar](255) NULL,
	[RegrettableLoss] [varchar](50) NULL,
	[LastUpdatedBy] [varchar](255) NULL,
	[LastUpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_EmployeeStatusHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeStatusHistory_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([id])
ALTER TABLE [dbo].[EmployeeStatusHistory] CHECK CONSTRAINT [FK_EmployeeStatusHistory_Employee]
ALTER TABLE [dbo].[EmployeeStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeStatusHistory_Status] FOREIGN KEY([StatusID])
REFERENCES [dbo].[Status] ([Id])
ALTER TABLE [dbo].[EmployeeStatusHistory] CHECK CONSTRAINT [FK_EmployeeStatusHistory_Status]
