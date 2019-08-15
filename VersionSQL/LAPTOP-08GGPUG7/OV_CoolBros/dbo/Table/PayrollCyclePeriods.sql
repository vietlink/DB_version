/****** Object:  Table [dbo].[PayrollCyclePeriods]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PayrollCyclePeriods](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](12) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Code] [varchar](5) NULL,
 CONSTRAINT [PK_PayrollCyclePeriods] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PayrollCyclePeriods] ADD  CONSTRAINT [DF_PayrollCyclePeriods_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
