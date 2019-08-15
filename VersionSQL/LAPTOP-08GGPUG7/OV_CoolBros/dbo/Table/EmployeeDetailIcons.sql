/****** Object:  Table [dbo].[EmployeeDetailIcons]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeDetailIcons](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IconIndex] [int] NOT NULL,
	[IconFileName] [varchar](256) NOT NULL,
	[IconType] [int] NOT NULL,
	[IconUrl] [varchar](256) NOT NULL,
	[IconTooltip] [varchar](256) NOT NULL,
	[GroupID] [int] NOT NULL,
	[AttributeID] [int] NOT NULL,
 CONSTRAINT [PK_EmployeeDetailIcons] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

