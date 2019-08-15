/****** Object:  Table [dbo].[Position]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Position](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](50) NOT NULL,
	[description] [varchar](255) NULL,
	[occupancystatus] [varchar](50) NULL,
	[type] [varchar](50) NULL,
	[startdate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[isassistant] [varchar](1) NULL,
	[orgunit1] [varchar](50) NULL,
	[orgunit2] [varchar](50) NULL,
	[orgunit3] [varchar](50) NULL,
	[orgunit4] [varchar](50) NULL,
	[orgunit5] [varchar](50) NULL,
	[orgunit6] [varchar](50) NULL,
	[orgunit7] [varchar](50) NULL,
	[orgunit8] [varchar](50) NULL,
	[orgunit9] [varchar](50) NULL,
	[orgunit10] [varchar](50) NULL,
	[location] [varchar](50) NULL,
	[parentid] [int] NULL,
	[identifier] [varchar](255) NOT NULL,
	[iFlag] [int] NULL,
	[posdate1] [datetime] NULL,
	[posdate2] [datetime] NULL,
	[posdate3] [datetime] NULL,
	[posdate4] [datetime] NULL,
	[posdate5] [datetime] NULL,
	[posdate6] [datetime] NULL,
	[posdate7] [datetime] NULL,
	[posdate8] [datetime] NULL,
	[posdate9] [datetime] NULL,
	[posdate10] [datetime] NULL,
	[posinteger1] [int] NULL,
	[posinteger2] [int] NULL,
	[posinteger3] [int] NULL,
	[posinteger4] [int] NULL,
	[posinteger5] [int] NULL,
	[posinteger6] [int] NULL,
	[posinteger7] [int] NULL,
	[posinteger8] [int] NULL,
	[posinteger9] [int] NULL,
	[posinteger10] [int] NULL,
	[posdecimal1] [decimal](18, 8) NULL,
	[posdecimal2] [decimal](18, 8) NULL,
	[posdecimal3] [decimal](18, 8) NULL,
	[posdecimal4] [decimal](18, 8) NULL,
	[posdecimal5] [decimal](18, 8) NULL,
	[posdecimal6] [decimal](18, 8) NULL,
	[posdecimal7] [decimal](18, 8) NULL,
	[posdecimal8] [decimal](18, 8) NULL,
	[posdecimal9] [decimal](18, 8) NULL,
	[posdecimal10] [decimal](18, 8) NULL,
	[postext1] [varchar](255) NULL,
	[postext2] [varchar](255) NULL,
	[postext3] [varchar](255) NULL,
	[postext4] [varchar](255) NULL,
	[postext5] [varchar](255) NULL,
	[postext6] [varchar](255) NULL,
	[postext7] [varchar](255) NULL,
	[postext8] [varchar](255) NULL,
	[postext9] [varchar](255) NULL,
	[postext10] [varchar](255) NULL,
	[posurl1] [varchar](1000) NULL,
	[posurl2] [varchar](1000) NULL,
	[posurl3] [varchar](1000) NULL,
	[posurl4] [varchar](1000) NULL,
	[posurl5] [varchar](1000) NULL,
	[posurl6] [varchar](1000) NULL,
	[posurl7] [varchar](1000) NULL,
	[posurl8] [varchar](1000) NULL,
	[posurl9] [varchar](1000) NULL,
	[posurl10] [varchar](1000) NULL,
	[parentpositionidentifier] [varchar](255) NULL,
	[plannedfte] [decimal](18, 8) NULL,
	[IsVisibleChart] [bit] NOT NULL,
	[IsUnassigned] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DefaultExclFromSubordCount] [varchar](1) NOT NULL,
	[CriticalPosition] [varchar](50) NULL,
	[ExecSeniorPosition] [varchar](50) NULL,
	[BudgetSalaryPerFTE] [decimal](18, 8) NULL,
	[PosCostCentre] [varchar](50) NULL,
	[FlexCorePosition] [varchar](50) NULL,
	[LeadtimeToRecruit] [decimal](18, 8) NULL,
	[BudgetEmployeeCount] [decimal](18, 8) NULL,
	[IsPlaceholder] [bit] NOT NULL,
	[ApprovalLevel] [int] NULL,
 CONSTRAINT [pkPosition] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [idxPositionIdentifier] ON [dbo].[Position]
(
	[identifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[Position] ADD  CONSTRAINT [DF_Position_isassistant]  DEFAULT ('N') FOR [isassistant]
ALTER TABLE [dbo].[Position] ADD  CONSTRAINT [DF_Position_IsVisibleChart]  DEFAULT ((1)) FOR [IsVisibleChart]
ALTER TABLE [dbo].[Position] ADD  CONSTRAINT [DF_Position_IsUnassigned]  DEFAULT ((0)) FOR [IsUnassigned]
ALTER TABLE [dbo].[Position] ADD  CONSTRAINT [DF_Position_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
ALTER TABLE [dbo].[Position] ADD  CONSTRAINT [DF_Position_DefaultExclFromSubordCount]  DEFAULT ('N') FOR [DefaultExclFromSubordCount]
ALTER TABLE [dbo].[Position] ADD  CONSTRAINT [DF_Position_IsPlaceholder]  DEFAULT ((0)) FOR [IsPlaceholder]
ALTER TABLE [dbo].[Position] ADD  CONSTRAINT [DF_Position_ApprovalLevel]  DEFAULT ((1)) FOR [ApprovalLevel]
ALTER TABLE [dbo].[Position]  WITH NOCHECK ADD  CONSTRAINT [FK_Position_Position] FOREIGN KEY([parentid])
REFERENCES [dbo].[Position] ([id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[Position] NOCHECK CONSTRAINT [FK_Position_Position]
