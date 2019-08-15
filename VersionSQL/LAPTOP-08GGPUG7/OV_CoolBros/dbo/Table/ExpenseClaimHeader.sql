/****** Object:  Table [dbo].[ExpenseClaimHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ExpenseClaimHeader](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExpenseClaimDate] [datetime] NULL,
	[Description] [varchar](250) NULL,
	[ExpenseClaimStatusID] [int] NULL,
	[isLocked] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[LastEditedDate] [datetime] NULL,
	[CreatedByUserID] [int] NULL,
	[LastEditedByUserID] [int] NULL,
	[CreatedForUserID] [int] NULL,
	[PayCycleID] [int] NULL,
	[isPartiallyApproved] [bit] NULL,
	[Comment] [varchar](200) NULL,
	[isAutoApproved] [bit] NULL,
	[ClaimType] [int] NULL,
 CONSTRAINT [PK_ExpenseClaimHeader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ExpenseClaimHeader] ADD  CONSTRAINT [DF_ExpenseClaimHeader_isPartiallyApproved]  DEFAULT ((0)) FOR [isPartiallyApproved]
ALTER TABLE [dbo].[ExpenseClaimHeader] ADD  CONSTRAINT [DF_ExpenseClaimHeader_isAutoApproved]  DEFAULT ((0)) FOR [isAutoApproved]
ALTER TABLE [dbo].[ExpenseClaimHeader] ADD  CONSTRAINT [DF_ExpenseClaimHeader_ClaimType]  DEFAULT ((0)) FOR [ClaimType]
ALTER TABLE [dbo].[ExpenseClaimHeader]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseClaimHeader_ExpenseStatus] FOREIGN KEY([ExpenseClaimStatusID])
REFERENCES [dbo].[ExpenseStatus] ([ID])
ALTER TABLE [dbo].[ExpenseClaimHeader] CHECK CONSTRAINT [FK_ExpenseClaimHeader_ExpenseStatus]
ALTER TABLE [dbo].[ExpenseClaimHeader]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseClaimHeader_PayrollCycle] FOREIGN KEY([PayCycleID])
REFERENCES [dbo].[PayrollCycle] ([ID])
ALTER TABLE [dbo].[ExpenseClaimHeader] CHECK CONSTRAINT [FK_ExpenseClaimHeader_PayrollCycle]
