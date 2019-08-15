/****** Object:  Table [dbo].[TimeShiftLoadingHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimeShiftLoadingHeader](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsCustom] [bit] NOT NULL,
	[Code] [varchar](10) NULL,
 CONSTRAINT [PK_TimeShiftLoadingHeader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TimeShiftLoadingHeader] ADD  CONSTRAINT [DF_TimeShiftLoadingHeader_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
ALTER TABLE [dbo].[TimeShiftLoadingHeader] ADD  CONSTRAINT [DF_TimeShiftLoadingHeader_IsCustom]  DEFAULT ((0)) FOR [IsCustom]
