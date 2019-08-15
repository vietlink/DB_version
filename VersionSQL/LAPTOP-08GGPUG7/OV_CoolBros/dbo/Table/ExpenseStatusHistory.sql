/****** Object:  Table [dbo].[ExpenseStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ExpenseStatusHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExpenseHeaderID] [int] NULL,
	[ExpenseStatusID] [int] NULL,
	[Date] [datetime] NULL,
	[SubmittedByID] [int] NULL,
	[ExpenseDetailID] [int] NULL,
	[ApprovedByID] [int] NULL,
 CONSTRAINT [PK_ExpenseStatusHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ExpenseStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseStatusHistory_ExpenseClaimDetail] FOREIGN KEY([ExpenseDetailID])
REFERENCES [dbo].[ExpenseClaimDetail] ([ID])
ALTER TABLE [dbo].[ExpenseStatusHistory] CHECK CONSTRAINT [FK_ExpenseStatusHistory_ExpenseClaimDetail]
ALTER TABLE [dbo].[ExpenseStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseStatusHistory_ExpenseClaimHeader] FOREIGN KEY([ExpenseHeaderID])
REFERENCES [dbo].[ExpenseClaimHeader] ([ID])
ALTER TABLE [dbo].[ExpenseStatusHistory] CHECK CONSTRAINT [FK_ExpenseStatusHistory_ExpenseClaimHeader]
ALTER TABLE [dbo].[ExpenseStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseStatusHistory_ExpenseStatus] FOREIGN KEY([ExpenseStatusID])
REFERENCES [dbo].[ExpenseStatus] ([ID])
ALTER TABLE [dbo].[ExpenseStatusHistory] CHECK CONSTRAINT [FK_ExpenseStatusHistory_ExpenseStatus]
