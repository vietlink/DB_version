/****** Object:  Table [dbo].[EmployeePositionHistory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeePositionHistory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[PositionID] [int] NOT NULL,
	[primaryposition] [varchar](1) NOT NULL,
	[startdate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[fte] [decimal](18, 8) NULL,
	[vacant] [varchar](1) NOT NULL,
	[ExclFromSubordCount] [varchar](1) NULL,
	[Managerial] [varchar](1) NULL,
	[ManagerID] [int] NULL,
 CONSTRAINT [PK_EmployeePositionHistory] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmployeePositionHistory]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePositionHistory_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([id])
ALTER TABLE [dbo].[EmployeePositionHistory] CHECK CONSTRAINT [FK_EmployeePositionHistory_Employee]
ALTER TABLE [dbo].[EmployeePositionHistory]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePositionHistory_Position] FOREIGN KEY([PositionID])
REFERENCES [dbo].[Position] ([id])
ALTER TABLE [dbo].[EmployeePositionHistory] CHECK CONSTRAINT [FK_EmployeePositionHistory_Position]
