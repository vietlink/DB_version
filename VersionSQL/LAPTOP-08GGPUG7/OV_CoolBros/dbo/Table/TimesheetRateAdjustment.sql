/****** Object:  Table [dbo].[TimesheetRateAdjustment]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimesheetRateAdjustment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TimesheetHeaderID] [int] NOT NULL,
	[Comment] [varchar](255) NOT NULL,
	[NormalRate] [decimal](10, 5) NOT NULL,
	[IsFinalisedHours] [bit] NOT NULL,
	[ToilRate] [decimal](10, 5) NOT NULL,
 CONSTRAINT [PK_TimesheetRateAdjustment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TimesheetRateAdjustment] ADD  CONSTRAINT [DF_TimesheetRateAdjustment_IsFinalisedHours]  DEFAULT ((0)) FOR [IsFinalisedHours]
ALTER TABLE [dbo].[TimesheetRateAdjustment] ADD  CONSTRAINT [DF_TimesheetRateAdjustment_ToilRate]  DEFAULT ((0)) FOR [ToilRate]
