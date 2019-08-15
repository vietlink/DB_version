/****** Object:  Table [dbo].[TimesheetRateAdjustmentItem]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimesheetRateAdjustmentItem](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TimesheetRateAdjustmentID] [int] NOT NULL,
	[RateID] [int] NOT NULL,
	[Balance] [decimal](10, 5) NOT NULL,
 CONSTRAINT [PK_TimesheetRateAdjustmentItem] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

