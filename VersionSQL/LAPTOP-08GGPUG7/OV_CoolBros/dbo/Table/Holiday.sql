/****** Object:  Table [dbo].[Holiday]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Holiday](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HolidayRegionID] [int] NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Holidays] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Holiday]  WITH NOCHECK ADD  CONSTRAINT [FK_Holiday_HolidayRegion] FOREIGN KEY([HolidayRegionID])
REFERENCES [dbo].[HolidayRegion] ([ID])
ALTER TABLE [dbo].[Holiday] CHECK CONSTRAINT [FK_Holiday_HolidayRegion]
