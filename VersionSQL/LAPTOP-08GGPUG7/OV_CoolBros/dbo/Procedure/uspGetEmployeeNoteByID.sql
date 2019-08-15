/****** Object:  Procedure [dbo].[uspGetEmployeeNoteByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeNoteByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		ner.Id,
		n.[Subject],
		n.Body,
		nt.Name as NoteType,
		nt.Id as NoteTypeID,
		CanEmpView,
		CreatedDateTime,
		UpdatedDateTime,
		createdAccount.accountname as CreatedUser,
		isnull(updatedAccount.accountname, '') as UpdatedUser
	FROM
		NotesEmployeeRelations ner
	INNER JOIN
		Notes n
	ON
		n.id = ner.noteid
	INNER JOIN
		NoteTypes nt
	ON
		nt.id = n.NoteTypeID
	INNER JOIN
		[User] createdAccount
	ON
		createdAccount.id = CreatedUserID
	LEFT OUTER JOIN
		[User] updatedAccount
	ON
		updatedAccount.id = UpdatedUserID
	WHERE
		ner.id = @id
END


