/****** Object:  Table [dbo].[Notes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Notes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Subject] [varchar](100) NOT NULL,
	[Body] [varchar](4000) NOT NULL,
	[NoteTypeID] [int] NOT NULL,
	[CanEmpView] [bit] NOT NULL,
	[CreatedUserID] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[PageType] [varchar](50) NOT NULL,
	[EmployeeUserID] [int] NULL,
	[UpdatedUserID] [int] NULL,
 CONSTRAINT [PK_Notes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Notes]  WITH CHECK ADD  CONSTRAINT [FK_Notes_NoteTypes] FOREIGN KEY([NoteTypeID])
REFERENCES [dbo].[NoteTypes] ([ID])
ALTER TABLE [dbo].[Notes] CHECK CONSTRAINT [FK_Notes_NoteTypes]
