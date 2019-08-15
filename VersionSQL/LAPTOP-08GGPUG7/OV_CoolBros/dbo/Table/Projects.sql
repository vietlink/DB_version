/****** Object:  Table [dbo].[Projects]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Projects](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[ClientID] [int] NOT NULL,
	[PayCostCentreID] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[ExpenseCostCentreID] [int] NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Projects] ADD  CONSTRAINT [DF_Projects_ClientID]  DEFAULT ((0)) FOR [ClientID]
ALTER TABLE [dbo].[Projects] ADD  CONSTRAINT [DF_Projects_PayCostCenterID]  DEFAULT ((0)) FOR [PayCostCentreID]
ALTER TABLE [dbo].[Projects] ADD  CONSTRAINT [DF_Projects_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
ALTER TABLE [dbo].[Projects] ADD  CONSTRAINT [DF_Projects_IsActive]  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_Client] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ID])
ALTER TABLE [dbo].[Projects] CHECK CONSTRAINT [FK_Projects_Client]
ALTER TABLE [dbo].[Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_CostCentre] FOREIGN KEY([PayCostCentreID])
REFERENCES [dbo].[CostCentres] ([ID])
ALTER TABLE [dbo].[Projects] CHECK CONSTRAINT [FK_Projects_CostCentre]
ALTER TABLE [dbo].[Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_CostCentres] FOREIGN KEY([ExpenseCostCentreID])
REFERENCES [dbo].[CostCentres] ([ID])
ALTER TABLE [dbo].[Projects] CHECK CONSTRAINT [FK_Projects_CostCentres]
