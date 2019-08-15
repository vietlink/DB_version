/****** Object:  Procedure [dbo].[uspGetCompetencyNoteByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompetencyNoteByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		ncr.Id,
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
		NotesCompetencyRelations ncr
	INNER JOIN
		Notes n
	ON
		n.id = ncr.noteid
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
		ncr.id = @id
END


