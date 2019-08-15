/****** Object:  Table [dbo].[NotesPositionRelations]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[NotesPositionRelations](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PositionID] [int] NOT NULL,
 CONSTRAINT [PK_NotesPositionRelations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[NotesPositionRelations]  WITH CHECK ADD  CONSTRAINT [FK_NotesPositionRelations_Notes] FOREIGN KEY([NoteID])
REFERENCES [dbo].[Notes] ([ID])
ALTER TABLE [dbo].[NotesPositionRelations] CHECK CONSTRAINT [FK_NotesPositionRelations_Notes]
ALTER TABLE [dbo].[NotesPositionRelations]  WITH CHECK ADD  CONSTRAINT [FK_NotesPositionRelations_Position] FOREIGN KEY([PositionID])
REFERENCES [dbo].[Position] ([id])
ALTER TABLE [dbo].[NotesPositionRelations] CHECK CONSTRAINT [FK_NotesPositionRelations_Position]
