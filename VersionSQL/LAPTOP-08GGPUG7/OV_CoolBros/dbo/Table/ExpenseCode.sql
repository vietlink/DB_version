/****** Object:  Table [dbo].[ExpenseCode]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ExpenseCode](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NULL,
	[isDeleted] [bit] NULL,
	[Code] [varchar](10) NULL,
 CONSTRAINT [PK_ExpenseCode] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ExpenseCode] ADD  CONSTRAINT [DF_ExpenseCode_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
