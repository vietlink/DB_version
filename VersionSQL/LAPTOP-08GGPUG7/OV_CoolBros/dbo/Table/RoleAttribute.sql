/****** Object:  Table [dbo].[RoleAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RoleAttribute](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[roleid] [dbo].[udtId] NOT NULL,
	[attributeid] [dbo].[udtId] NOT NULL,
	[granted] [dbo].[udtYesNo] NOT NULL,
 CONSTRAINT [pkRoleAttribute] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [idxRoleAttribute] ON [dbo].[RoleAttribute]
(
	[roleid] ASC,
	[attributeid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[RoleAttribute]  WITH CHECK ADD  CONSTRAINT [FK_RoleAttribute_Attribute] FOREIGN KEY([attributeid])
REFERENCES [dbo].[Attribute] ([id])
ALTER TABLE [dbo].[RoleAttribute] CHECK CONSTRAINT [FK_RoleAttribute_Attribute]
ALTER TABLE [dbo].[RoleAttribute]  WITH CHECK ADD  CONSTRAINT [FK_RoleAttribute_Role] FOREIGN KEY([roleid])
REFERENCES [dbo].[Role] ([id])
ALTER TABLE [dbo].[RoleAttribute] CHECK CONSTRAINT [FK_RoleAttribute_Role]
