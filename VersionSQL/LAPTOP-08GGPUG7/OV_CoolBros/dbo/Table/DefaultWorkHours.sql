/****** Object:  Table [dbo].[DefaultWorkHours]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DefaultWorkHours](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Day] [varchar](10) NOT NULL,
	[StartTime] [varchar](8) NULL,
	[EndTime] [varchar](8) NULL,
	[Hours] [decimal](5, 2) NULL,
	[ExtraHours] [decimal](5, 2) NULL,
	[IsEnabled] [bit] NOT NULL,
	[Week] [int] NOT NULL,
	[DayShortCode] [varchar](5) NULL,
	[BreaKMinutes] [decimal](5, 2) NULL,
	[OvertimeStartsAfter] [decimal](5, 2) NULL,
 CONSTRAINT [PK_DefaultWorkHours] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DefaultWorkHours] ADD  CONSTRAINT [DF_DefaultWorkHours_IsEnabled]  DEFAULT ((0)) FOR [IsEnabled]
ALTER TABLE [dbo].[DefaultWorkHours] ADD  CONSTRAINT [DF_DefaultWorkHours_Week]  DEFAULT ((1)) FOR [Week]
