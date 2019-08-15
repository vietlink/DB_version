/****** Object:  Table [dbo].[RolePolicy]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RolePolicy](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[roleid] [dbo].[udtId] NOT NULL,
	[policyid] [dbo].[udtId] NOT NULL,
	[granted] [dbo].[udtYesNo] NOT NULL,
 CONSTRAINT [pkRolePolicy] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [idxRolePolicy] ON [dbo].[RolePolicy]
(
	[roleid] ASC,
	[policyid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[RolePolicy]  WITH CHECK ADD  CONSTRAINT [FK_RolePolicy_Policy] FOREIGN KEY([policyid])
REFERENCES [dbo].[Policy] ([id])
ALTER TABLE [dbo].[RolePolicy] CHECK CONSTRAINT [FK_RolePolicy_Policy]
ALTER TABLE [dbo].[RolePolicy]  WITH CHECK ADD  CONSTRAINT [FK_RolePolicy_Role] FOREIGN KEY([roleid])
REFERENCES [dbo].[Role] ([id])
ALTER TABLE [dbo].[RolePolicy] CHECK CONSTRAINT [FK_RolePolicy_Role]
