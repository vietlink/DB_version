/****** Object:  Table [dbo].[EmployeeGroupEmployee]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeGroupEmployee](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[employeeid] [dbo].[udtId] NOT NULL,
	[employeegroupid] [dbo].[udtId] NOT NULL,
	[empidentifier] [dbo].[udtLongName] NOT NULL,
	[IsLeader] [bit] NOT NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [pkEmployeeGroupEmployee] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [idxEmployeeGroupEmployee] ON [dbo].[EmployeeGroupEmployee]
(
	[employeeid] ASC,
	[employeegroupid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[EmployeeGroupEmployee] ADD  CONSTRAINT [DF_EmployeeGroupEmployee_IsLeader]  DEFAULT ((0)) FOR [IsLeader]
ALTER TABLE [dbo].[EmployeeGroupEmployee]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeGroupEmployee_Employee] FOREIGN KEY([employeeid])
REFERENCES [dbo].[Employee] ([id])
ALTER TABLE [dbo].[EmployeeGroupEmployee] CHECK CONSTRAINT [FK_EmployeeGroupEmployee_Employee]
ALTER TABLE [dbo].[EmployeeGroupEmployee]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeGroupEmployee_EmployeeGroup] FOREIGN KEY([employeegroupid])
REFERENCES [dbo].[EmployeeGroup] ([id])
ALTER TABLE [dbo].[EmployeeGroupEmployee] CHECK CONSTRAINT [FK_EmployeeGroupEmployee_EmployeeGroup]
