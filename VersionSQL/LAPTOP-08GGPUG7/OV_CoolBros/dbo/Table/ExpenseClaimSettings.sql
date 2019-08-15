/****** Object:  Table [dbo].[ExpenseClaimSettings]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ExpenseClaimSettings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Approver1] [int] NULL,
	[Approver1PositionID] [int] NULL,
	[CostCentreReqFlag] [bit] NULL,
	[CostCentreText] [varchar](15) NULL,
	[ExpenseCodeText] [varchar](15) NULL,
	[AccountCodeReqFlag] [bit] NULL,
	[AccountCodeText] [varchar](15) NULL,
	[TaxReqFlag] [bit] NULL,
	[TaxText] [varchar](15) NULL,
	[SendApproverEmailFlag] [bit] NULL,
	[SendApproverEmailText] [varchar](max) NULL,
	[SendEmailApproverFlag] [bit] NULL,
	[SendEmailApproverText] [varchar](max) NULL,
	[SendEmailRejectFlag] [bit] NULL,
	[SendEmailRejectText] [varchar](max) NULL,
	[TaxValue] [decimal](5, 2) NULL,
	[MileageRatePaid] [decimal](5, 2) NULL,
	[MileageRateGov] [decimal](5, 2) NULL,
	[MilesKm] [varchar](5) NULL,
	[ExportMileageClaimAs] [varchar](7) NULL,
	[ExpClaimMsg] [varchar](200) NULL,
	[MileageClaimMsg] [varchar](200) NULL,
	[IsExpenseRecieptRequired] [bit] NULL,
	[DefaultExpenseCodeID] [int] NULL,
	[TaxCode] [varchar](20) NULL,
	[NoTaxCode] [varchar](20) NULL,
	[CurrencyCode] [varchar](20) NULL,
	[MileageNonTaxExpenseCodeID] [int] NULL,
 CONSTRAINT [PK_ExpenseClaimSettings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[ExpenseClaimSettings] ADD  CONSTRAINT [DF_ExpenseClaimSettings_IsExpenseRecieptRequired]  DEFAULT ((0)) FOR [IsExpenseRecieptRequired]
ALTER TABLE [dbo].[ExpenseClaimSettings]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseClaimSettings_ExpenseCode] FOREIGN KEY([DefaultExpenseCodeID])
REFERENCES [dbo].[ExpenseCode] ([ID])
ALTER TABLE [dbo].[ExpenseClaimSettings] CHECK CONSTRAINT [FK_ExpenseClaimSettings_ExpenseCode]
ALTER TABLE [dbo].[ExpenseClaimSettings]  WITH CHECK ADD  CONSTRAINT [FK_ExpenseClaimSettings_ExpenseCode1] FOREIGN KEY([MileageNonTaxExpenseCodeID])
REFERENCES [dbo].[ExpenseCode] ([ID])
ALTER TABLE [dbo].[ExpenseClaimSettings] CHECK CONSTRAINT [FK_ExpenseClaimSettings_ExpenseCode1]
