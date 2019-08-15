/****** Object:  Table [dbo].[SearchPageSizes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SearchPageSizes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PageSizeText] [int] NOT NULL,
	[PageSizeValue] [int] NULL,
 CONSTRAINT [PK_SearchPageSizes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

