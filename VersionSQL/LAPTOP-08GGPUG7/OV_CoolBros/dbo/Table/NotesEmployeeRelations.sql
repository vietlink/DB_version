/****** Object:  Table [dbo].[NotesEmployeeRelations]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[NotesEmployeeRelations](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
 CONSTRAINT [PK_NotesEmployeeRelations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[NotesEmployeeRelations]  WITH CHECK ADD  CONSTRAINT [FK_NotesEmployeeRelations_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([id])
ALTER TABLE [dbo].[NotesEmployeeRelations] CHECK CONSTRAINT [FK_NotesEmployeeRelations_Employee]
ALTER TABLE [dbo].[NotesEmployeeRelations]  WITH CHECK ADD  CONSTRAINT [FK_NotesEmployeeRelations_Notes] FOREIGN KEY([NoteID])
REFERENCES [dbo].[Notes] ([ID])
ALTER TABLE [dbo].[NotesEmployeeRelations] CHECK CONSTRAINT [FK_NotesEmployeeRelations_Notes]
