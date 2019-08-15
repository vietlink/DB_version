/****** Object:  Table [dbo].[LeaveTransactionTypes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeaveTransactionTypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[SortOrder] [int] NOT NULL,
 CONSTRAINT [PK_LeaveTransactionTypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LeaveTransactionTypes] ADD  CONSTRAINT [DF_LeaveTransactionTypes_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
