/****** Object:  Table [dbo].[TimeWorkHoursHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimeWorkHoursHeader](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[WeekPattern] [int] NOT NULL,
 CONSTRAINT [PK_TimeWorkHoursHeader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TimeWorkHoursHeader] ADD  CONSTRAINT [DF_TimeWorkHoursHeader_WeekPattern]  DEFAULT ((0)) FOR [WeekPattern]
