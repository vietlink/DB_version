/****** Object:  Procedure [dbo].[uspAddUpdatePositionNote]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdatePositionNote](@positionid int, @relationshipid int, @subject varchar(100), @body varchar(4000), @userId int,
	@typeId int, @pageType varchar(50), @canEmpView bit, @dateTime datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @noteId int = 0;

	IF @relationshipid <> 0 BEGIN
		SELECT @noteId = noteid FROM NotesPositionRelations WHERE id = @relationshipid
		IF (@noteId > 0) BEGIN
			UPDATE 
				Notes
			SET
				[subject] = @subject,
				body = @body,
				NoteTypeID = @typeId,
				CanEmpView = @canEmpView,
				UpdatedDateTime = @dateTime,
				UpdatedUserID = @userId
			WHERE
				id = @noteId
			RETURN;
		END
    END

	INSERT INTO Notes([subject], body, NoteTypeID, PageType, CreatedDateTime, CanEmpView, CreatedUserID, UpdatedDateTime, UpdatedUserID)
		VALUES(@subject, @body, @typeId, @pageType, @dateTime, @canEmpView, @userId, @dateTime, @userId)
	SET @noteId = @@IDENTITY;
	INSERT INTO NotesPositionRelations(NoteID, PositionID)
		VALUES(@noteId, @positionid)
END


