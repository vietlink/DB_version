/****** Object:  Table [dbo].[ErrorTab]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ErrorTab](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorDescription] [varchar](8000) NULL,
	[ErrorNumber] [varchar](5000) NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_ErrorTab] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ErrorTab] ADD  CONSTRAINT [DF_ErrorTab_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
