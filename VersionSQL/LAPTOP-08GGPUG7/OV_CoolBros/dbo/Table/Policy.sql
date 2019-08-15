/****** Object:  Table [dbo].[Policy]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Policy](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[ModuleId] [dbo].[udtId] NOT NULL,
	[code] [dbo].[udtCode] NOT NULL,
	[name] [dbo].[udtName] NOT NULL,
	[description] [dbo].[udtDescription] NOT NULL,
	[type] [dbo].[udtName] NOT NULL,
 CONSTRAINT [pkPolicy] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [idxPolicyName] ON [dbo].[Policy]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[Policy] ADD  CONSTRAINT [DF_Policy_ModuleId]  DEFAULT ((0)) FOR [ModuleId]
