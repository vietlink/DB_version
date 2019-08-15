/****** Object:  Table [dbo].[Documents]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Documents](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](260) NOT NULL,
	[StoreName] [varchar](100) NOT NULL,
	[Directory] [varchar](260) NOT NULL,
	[DataID] [int] NOT NULL,
	[PageType] [varchar](50) NOT NULL,
	[Size] [varchar](20) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](100) NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedBy] [varchar](100) NULL,
 CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Documents] ADD  CONSTRAINT [DF_Documents_Enabled]  DEFAULT ((1)) FOR [Enabled]
ALTER TABLE [dbo].[Documents] ADD  CONSTRAINT [DF_Documents_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
