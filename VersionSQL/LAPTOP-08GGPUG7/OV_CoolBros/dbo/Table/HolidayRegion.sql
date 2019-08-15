/****** Object:  Table [dbo].[HolidayRegion]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[HolidayRegion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Code] [varchar](10) NULL,
 CONSTRAINT [PK_HolidayRegion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[HolidayRegion] ADD  CONSTRAINT [DF_HolidayRegion_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
ALTER TABLE [dbo].[HolidayRegion] ADD  CONSTRAINT [DF_HolidayRegion_IsEnable]  DEFAULT ((0)) FOR [IsDeleted]
