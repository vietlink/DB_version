/****** Object:  Table [dbo].[PolicyModules]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PolicyModules](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Modulename] [varchar](50) NOT NULL,
	[Sectioname] [varchar](50) NULL,
	[PageURL] [varchar](200) NULL,
	[Ordering] [int] NULL,
 CONSTRAINT [PK_PolicyModules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

