/****** Object:  Table [dbo].[ExpenseClaimDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ExpenseClaimDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExpenseClaimHeaderID] [int] NULL,
	[ExpenseTypeID] [int] NULL,
	[ExpenseDate] [datetime] NULL,
	[Description] [varchar](max) NULL,
	[ExpenseAmount] [decimal](10, 2) NULL,
	[TaxFlag] [bit] NULL,
	[TaxAmount] [decimal](8, 2) NULL,
	[Source] [varchar](max) NULL,
	[Destination] [varchar](max) NULL,
	[StartMileage] [decimal](7, 1) NULL,
	[EndMileage] [decimal](7, 1) NULL,
	[TotalMileage] [decimal](7, 1) NULL,
	[CompanyTravelRate] [decimal](5, 2) NULL,
	[GovernmentTravelRate] [decimal](5, 2) NULL,
	[CostCentreExpenseFlag] [bit] NULL,
	[AccountFlag] [bit] NULL,
	[CostCentreID] [int] NULL,
	[ExpenseCodeID] [int] NULL,
	[ExpenseStatusID] [int] NULL,
	[IsLocked] [bit] NULL,
	[IsDocAttached] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[LastEditedDate] [datetime] NULL,
	[CreatedByUserID] [int] NULL,
	[LastEditedByUserID] [int] NULL,
	[DocumentID] [int] NULL,
	[PayCycleID] [int] NULL,
 CONSTRAINT [PK_ExpenseClaimDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[ExpenseClaimDetail]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseClaimDetail_CostCentres] FOREIGN KEY([CostCentreID])
REFERENCES [dbo].[CostCentres] ([ID])
ALTER TABLE [dbo].[ExpenseClaimDetail] CHECK CONSTRAINT [FK_ExpenseClaimDetail_CostCentres]
ALTER TABLE [dbo].[ExpenseClaimDetail]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseClaimDetail_ExpenseClaimDetail] FOREIGN KEY([ID])
REFERENCES [dbo].[ExpenseClaimDetail] ([ID])
ALTER TABLE [dbo].[ExpenseClaimDetail] CHECK CONSTRAINT [FK_ExpenseClaimDetail_ExpenseClaimDetail]
ALTER TABLE [dbo].[ExpenseClaimDetail]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseClaimDetail_ExpenseClaimHeader] FOREIGN KEY([ExpenseClaimHeaderID])
REFERENCES [dbo].[ExpenseClaimHeader] ([ID])
ALTER TABLE [dbo].[ExpenseClaimDetail] CHECK CONSTRAINT [FK_ExpenseClaimDetail_ExpenseClaimHeader]
ALTER TABLE [dbo].[ExpenseClaimDetail]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseClaimDetail_ExpenseCode] FOREIGN KEY([ExpenseCodeID])
REFERENCES [dbo].[ExpenseCode] ([ID])
ALTER TABLE [dbo].[ExpenseClaimDetail] CHECK CONSTRAINT [FK_ExpenseClaimDetail_ExpenseCode]
ALTER TABLE [dbo].[ExpenseClaimDetail]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseClaimDetail_ExpenseStatus] FOREIGN KEY([ExpenseStatusID])
REFERENCES [dbo].[ExpenseStatus] ([ID])
ALTER TABLE [dbo].[ExpenseClaimDetail] CHECK CONSTRAINT [FK_ExpenseClaimDetail_ExpenseStatus]
ALTER TABLE [dbo].[ExpenseClaimDetail]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseClaimDetail_ExpenseType] FOREIGN KEY([ExpenseTypeID])
REFERENCES [dbo].[ExpenseType] ([ID])
ALTER TABLE [dbo].[ExpenseClaimDetail] CHECK CONSTRAINT [FK_ExpenseClaimDetail_ExpenseType]
