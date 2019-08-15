/****** Object:  Procedure [dbo].[uspDeleteNote]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteNote](@id int, @type varchar(50))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @noteId int = 0;

    IF @type = 'employee' BEGIN
		SELECT @noteId = noteId FROM NotesEmployeeRelations WHERE ID = @id;
		DELETE FROM NotesEmployeeRelations WHERE ID = @id;
		DELETE FROM notes WHERE id = @noteId;
	END

	IF @type = 'position' BEGIN
		SELECT @noteId = noteId FROM NotesPositionRelations WHERE ID = @id;
		DELETE FROM NotesPositionRelations WHERE ID = @id;
		DELETE FROM notes WHERE id = @noteId;
	END

		IF @type = 'competency' OR @type = 'compliance' BEGIN
		SELECT @noteId = noteId FROM NotesPositionRelations WHERE ID = @id;
		DELETE FROM NotesCompetencyRelations WHERE ID = @id;
		DELETE FROM notes WHERE id = @noteId;
	END
END
