/****** Object:  Table [dbo].[AuthenticationMethod]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AuthenticationMethod](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[code] [dbo].[udtCode] NOT NULL,
	[name] [dbo].[udtName] NOT NULL,
	[enabled] [dbo].[udtYesNo] NOT NULL,
	[domainname] [dbo].[udtURL] NULL,
	[ou] [dbo].[udtURL] NULL,
	[accountname] [dbo].[udtLongName] NULL,
	[password] [dbo].[udtLongName] NULL,
 CONSTRAINT [pkAuthenticationMethod] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [idxAuthenticationMethodName] ON [dbo].[AuthenticationMethod]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
