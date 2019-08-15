/****** Object:  Table [dbo].[EmployeeComplianceHistory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeComplianceHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[ListID] [int] NOT NULL,
	[DateFrom] [datetime] NULL,
	[DateTo] [datetime] NULL,
	[Reference] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](100) NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedBy] [varchar](100) NOT NULL,
	[EmployeeCompetencyListID] [int] NULL,
	[IssueDate] [datetime] NULL,
	[AdditionalInfo] [varchar](1000) NULL,
	[ScoreDecimal] [decimal](18, 1) NULL,
	[ScoreAlpha] [varchar](15) NULL,
	[ScoreRange] [int] NULL,
	[ScoreType] [int] NULL,
	[IsMandatory] [bit] NOT NULL,
	[IsPositionMandatory] [bit] NOT NULL,
	[IsPositionRequirement] [bit] NOT NULL,
	[HasCompliance] [bit] NOT NULL,
	[NoLongerRequiredDate] [datetime] NULL,
 CONSTRAINT [PK_EmployeeComplianceHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeComplianceHistory] ADD  CONSTRAINT [DF_EmployeeComplianceHistory_IsMandatory]  DEFAULT ((1)) FOR [IsMandatory]
ALTER TABLE [dbo].[EmployeeComplianceHistory] ADD  CONSTRAINT [DF_EmployeeComplianceHistory_IsPositionMandatory]  DEFAULT ((0)) FOR [IsPositionMandatory]
ALTER TABLE [dbo].[EmployeeComplianceHistory] ADD  CONSTRAINT [DF_EmployeeComplianceHistory_IsPositionRequirement]  DEFAULT ((0)) FOR [IsPositionRequirement]
ALTER TABLE [dbo].[EmployeeComplianceHistory] ADD  CONSTRAINT [DF_EmployeeComplianceHistory_HasCompliance]  DEFAULT ((1)) FOR [HasCompliance]
ALTER TABLE [dbo].[EmployeeComplianceHistory]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeComplianceHistory_CompetencyList] FOREIGN KEY([ListID])
REFERENCES [dbo].[CompetencyList] ([Id])
ALTER TABLE [dbo].[EmployeeComplianceHistory] CHECK CONSTRAINT [FK_EmployeeComplianceHistory_CompetencyList]
ALTER TABLE [dbo].[EmployeeComplianceHistory]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeComplianceHistory_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([id])
ALTER TABLE [dbo].[EmployeeComplianceHistory] CHECK CONSTRAINT [FK_EmployeeComplianceHistory_Employee]
