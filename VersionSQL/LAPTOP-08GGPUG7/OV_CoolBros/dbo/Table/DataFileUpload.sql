/****** Object:  Table [dbo].[DataFileUpload]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DataFileUpload](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](250) NOT NULL,
	[FilePath] [varchar](250) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ProcessedDate] [datetime] NULL,
	[ProcessStartDate] [datetime] NULL,
	[IsProcessed] [bit] NOT NULL,
	[HasErrors] [bit] NOT NULL,
	[CreatedBy] [varchar](100) NULL,
	[BatchID] [uniqueidentifier] NULL,
	[HasIssues] [bit] NOT NULL,
 CONSTRAINT [PK_DataFileUpload] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DataFileUpload] ADD  CONSTRAINT [DF_DataFileUpload_IsProcessed]  DEFAULT ((0)) FOR [IsProcessed]
ALTER TABLE [dbo].[DataFileUpload] ADD  CONSTRAINT [DF_DataFileUpload_HasErrors]  DEFAULT ((0)) FOR [HasErrors]
ALTER TABLE [dbo].[DataFileUpload] ADD  CONSTRAINT [DF_DataFileUpload_HasIssues]  DEFAULT ((0)) FOR [HasIssues]
