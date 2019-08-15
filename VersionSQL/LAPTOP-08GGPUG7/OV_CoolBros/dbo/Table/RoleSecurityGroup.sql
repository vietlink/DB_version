/****** Object:  Table [dbo].[RoleSecurityGroup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RoleSecurityGroup](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[roleid] [dbo].[udtId] NOT NULL,
	[securitygroupid] [dbo].[udtId] NOT NULL,
 CONSTRAINT [pkRoleSecurityGroup] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [idxRoleSecurityGroup] ON [dbo].[RoleSecurityGroup]
(
	[roleid] ASC,
	[securitygroupid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[RoleSecurityGroup]  WITH CHECK ADD  CONSTRAINT [FK_RoleSecurityGroup_Role] FOREIGN KEY([roleid])
REFERENCES [dbo].[Role] ([id])
ALTER TABLE [dbo].[RoleSecurityGroup] CHECK CONSTRAINT [FK_RoleSecurityGroup_Role]
ALTER TABLE [dbo].[RoleSecurityGroup]  WITH CHECK ADD  CONSTRAINT [FK_RoleSecurityGroup_SecurityGroup] FOREIGN KEY([securitygroupid])
REFERENCES [dbo].[SecurityGroup] ([id])
ALTER TABLE [dbo].[RoleSecurityGroup] CHECK CONSTRAINT [FK_RoleSecurityGroup_SecurityGroup]
