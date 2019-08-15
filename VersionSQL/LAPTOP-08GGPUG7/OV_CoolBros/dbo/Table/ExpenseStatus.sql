/****** Object:  Table [dbo].[ExpenseStatus]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ExpenseStatus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](10) NULL,
	[Code] [varchar](50) NULL,
	[ShortDescription] [varchar](50) NULL,
 CONSTRAINT [PK_ExpenseStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

