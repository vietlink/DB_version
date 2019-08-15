/****** Object:  Table [dbo].[ApplicationPreference]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ApplicationPreference](
	[id] [dbo].[udtId] IDENTITY(1,1) NOT NULL,
	[preferenceid] [dbo].[udtId] NOT NULL,
	[type] [dbo].[udtCode] NOT NULL,
	[value] [dbo].[udtValue] NULL,
 CONSTRAINT [pkApplicationPreference] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [idxApplicationPreference] ON [dbo].[ApplicationPreference]
(
	[preferenceid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[ApplicationPreference]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationPreference_Preference] FOREIGN KEY([preferenceid])
REFERENCES [dbo].[Preference] ([id])
ALTER TABLE [dbo].[ApplicationPreference] CHECK CONSTRAINT [FK_ApplicationPreference_Preference]
