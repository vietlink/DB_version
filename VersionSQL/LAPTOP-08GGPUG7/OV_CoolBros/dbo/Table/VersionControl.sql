/****** Object:  Table [dbo].[VersionControl]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VersionControl](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VersionNumber] [varchar](50) NOT NULL,
	[BuildDate] [datetime] NOT NULL,
 CONSTRAINT [PK_VersionControl] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

