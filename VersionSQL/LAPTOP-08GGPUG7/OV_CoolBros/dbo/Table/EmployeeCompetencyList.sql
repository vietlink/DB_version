/****** Object:  Table [dbo].[EmployeeCompetencyList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeCompetencyList](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Employeeid] [int] NOT NULL,
	[CompetencyListId] [int] NOT NULL,
	[EmployeeCompetencyRankingId] [int] NULL,
	[DateFrom] [datetime] NULL,
	[DateTo] [datetime] NULL,
	[iHaveThis] [bit] NOT NULL,
	[Reference] [varchar](50) NULL,
	[IsPositionRequirement] [bit] NOT NULL,
	[IsMandatory] [bit] NOT NULL,
	[HasCompliance] [bit] NOT NULL,
	[NoLongerRequiredDate] [datetime] NULL,
 CONSTRAINT [PK_EmployeeCategoryDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeeCompetencyList] ADD  CONSTRAINT [DF_EmployeeCompetencyList_iHaveThis]  DEFAULT ((1)) FOR [iHaveThis]
ALTER TABLE [dbo].[EmployeeCompetencyList] ADD  CONSTRAINT [DF_EmployeeCompetencyList_IsPositionRequirement]  DEFAULT ((0)) FOR [IsPositionRequirement]
ALTER TABLE [dbo].[EmployeeCompetencyList] ADD  CONSTRAINT [DF_EmployeeCompetencyList_IsMandatory]  DEFAULT ((1)) FOR [IsMandatory]
ALTER TABLE [dbo].[EmployeeCompetencyList] ADD  CONSTRAINT [DF_EmployeeCompetencyList_HasCompliance]  DEFAULT ((1)) FOR [HasCompliance]
ALTER TABLE [dbo].[EmployeeCompetencyList]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCompetencyList_CompetencyList] FOREIGN KEY([CompetencyListId])
REFERENCES [dbo].[CompetencyList] ([Id])
ALTER TABLE [dbo].[EmployeeCompetencyList] CHECK CONSTRAINT [FK_EmployeeCompetencyList_CompetencyList]
ALTER TABLE [dbo].[EmployeeCompetencyList]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCompetencyList_Employee] FOREIGN KEY([Employeeid])
REFERENCES [dbo].[Employee] ([id])
ALTER TABLE [dbo].[EmployeeCompetencyList] CHECK CONSTRAINT [FK_EmployeeCompetencyList_Employee]
ALTER TABLE [dbo].[EmployeeCompetencyList]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCompetencyList_EmployeeCompetencyRankings] FOREIGN KEY([EmployeeCompetencyRankingId])
REFERENCES [dbo].[EmployeeCompetencyRankings] ([Id])
ALTER TABLE [dbo].[EmployeeCompetencyList] CHECK CONSTRAINT [FK_EmployeeCompetencyList_EmployeeCompetencyRankings]
