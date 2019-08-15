/****** Object:  Table [dbo].[Setting]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Setting](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[code] [varchar](50) NOT NULL,
	[name] [dbo].[udtName] NOT NULL,
	[description] [dbo].[udtDescription] NOT NULL,
	[value] [dbo].[udtValue] NULL,
	[datatype] [dbo].[udtName] NOT NULL,
	[usereditable] [dbo].[udtYesNo] NOT NULL,
	[Ordering] [int] NULL,
 CONSTRAINT [PK_Setting] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [idxSettingName] ON [dbo].[Setting]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
