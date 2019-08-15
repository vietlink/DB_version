/****** Object:  Table [dbo].[CostCentres]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CostCentres](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsPayrollCostCentre] [bit] NOT NULL,
	[IsExpenseCostCentre] [bit] NOT NULL,
 CONSTRAINT [PK_CostCentre] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[CostCentres] ADD  CONSTRAINT [DF_CostCentre_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
ALTER TABLE [dbo].[CostCentres] ADD  CONSTRAINT [DF_CostCentres_IsPayrollCostCentre]  DEFAULT ((0)) FOR [IsPayrollCostCentre]
ALTER TABLE [dbo].[CostCentres] ADD  CONSTRAINT [DF_CostCentres_IsExpenseCostCentre]  DEFAULT ((0)) FOR [IsExpenseCostCentre]
