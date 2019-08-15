/****** Object:  Table [dbo].[EmployeePosition]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeePosition](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[employeeid] [int] NOT NULL,
	[positionid] [int] NOT NULL,
	[primaryposition] [varchar](1) NULL,
	[startdate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[fte] [decimal](18, 8) NULL,
	[vacant] [varchar](1) NOT NULL,
	[iFlag] [int] NULL,
	[Managerial] [varchar](1) NULL,
	[ExclFromSubordCount] [varchar](1) NULL,
	[empposinteger1] [int] NULL,
	[empposinteger2] [int] NULL,
	[empposinteger3] [int] NULL,
	[empposinteger4] [int] NULL,
	[empposinteger5] [int] NULL,
	[empposdecimal1] [decimal](18, 8) NULL,
	[empposdecimal2] [decimal](18, 8) NULL,
	[empposdecimal3] [decimal](18, 8) NULL,
	[empposdecimal4] [decimal](18, 8) NULL,
	[empposdecimal5] [decimal](18, 8) NULL,
	[emppostext1] [varchar](255) NULL,
	[emppostext2] [varchar](255) NULL,
	[emppostext3] [varchar](255) NULL,
	[emppostext4] [varchar](255) NULL,
	[emppostext5] [varchar](255) NULL,
	[empposdate1] [datetime] NULL,
	[empposdate2] [datetime] NULL,
	[empposdate3] [datetime] NULL,
	[empposdate4] [datetime] NULL,
	[empposdate5] [datetime] NULL,
	[empposurl1] [varchar](1000) NULL,
	[empposurl2] [varchar](1000) NULL,
	[empposurl3] [varchar](1000) NULL,
	[empposurl4] [varchar](1000) NULL,
	[empposurl5] [varchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[ManagerID] [int] NULL,
 CONSTRAINT [pkEmployeePosition] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_EmployeeID_PositionID] UNIQUE NONCLUSTERED 
(
	[positionid] ASC,
	[employeeid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeePosition] ADD  CONSTRAINT [Vacant_Constr]  DEFAULT ('N') FOR [vacant]
ALTER TABLE [dbo].[EmployeePosition] ADD  CONSTRAINT [Manaherial_Constr]  DEFAULT ('N') FOR [Managerial]
ALTER TABLE [dbo].[EmployeePosition] ADD  CONSTRAINT [exclSubCount_Constr]  DEFAULT ('N') FOR [ExclFromSubordCount]
ALTER TABLE [dbo].[EmployeePosition] ADD  CONSTRAINT [DF_EmployeePosition_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
ALTER TABLE [dbo].[EmployeePosition]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePosition_Employee] FOREIGN KEY([employeeid])
REFERENCES [dbo].[Employee] ([id])
ALTER TABLE [dbo].[EmployeePosition] CHECK CONSTRAINT [FK_EmployeePosition_Employee]
ALTER TABLE [dbo].[EmployeePosition]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePosition_Position] FOREIGN KEY([positionid])
REFERENCES [dbo].[Position] ([id])
ALTER TABLE [dbo].[EmployeePosition] CHECK CONSTRAINT [FK_EmployeePosition_Position]
