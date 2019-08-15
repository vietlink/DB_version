/****** Object:  Table [dbo].[Role]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Role](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[code] [dbo].[udtCode] NOT NULL,
	[name] [dbo].[udtName] NOT NULL,
	[description] [dbo].[udtDescription] NOT NULL,
	[type] [dbo].[udtName] NOT NULL,
	[enabled] [dbo].[udtYesNo] NOT NULL,
	[usereditable] [dbo].[udtYesNo] NOT NULL,
	[IsLoadRole] [bit] NOT NULL,
 CONSTRAINT [pkRole] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [idxRoleName] ON [dbo].[Role]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[Role] ADD  CONSTRAINT [DF_Role_isloadgroup]  DEFAULT ((0)) FOR [IsLoadRole]
