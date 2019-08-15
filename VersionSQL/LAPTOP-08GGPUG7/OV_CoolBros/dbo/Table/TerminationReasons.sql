/****** Object:  Table [dbo].[TerminationReasons]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TerminationReasons](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](80) NOT NULL,
	[Grouping] [varchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_TerminationReasons] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TerminationReasons] ADD  CONSTRAINT [DF_TerminationReasons_IsDelete]  DEFAULT ((0)) FOR [IsDeleted]
