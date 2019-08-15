/****** Object:  Table [dbo].[EmployeeGroup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeGroup](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[code] [dbo].[udtCode] NOT NULL,
	[name] [dbo].[udtName] NOT NULL,
	[icon] [dbo].[udtURL] NOT NULL,
	[interfaceid] [dbo].[udtId] NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](100) NULL,
	[UpdatedDate] [datetime] NULL,
	[PermissionLevel] [int] NOT NULL,
 CONSTRAINT [pkEmployeeGroup] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [idxEmployeeGroupName] ON [dbo].[EmployeeGroup]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[EmployeeGroup] ADD  CONSTRAINT [DF_EmployeeGroup_PermissionLevel]  DEFAULT ((0)) FOR [PermissionLevel]
