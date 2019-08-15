/****** Object:  Procedure [dbo].[uspGetPositionNotes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetPositionNotes](@posId int, @userId int, @filterTypeId int, @filterSearch varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		npr.Id,
		n.[Subject],
		n.Body,
		nt.Name as NoteType,
		CanEmpView,
		CreatedDateTime,
		UpdatedDateTime,
		CreatedUserID,
		createdAccount.accountname as CreatedUser,
		isnull(updatedAccount.accountname, '') as UpdatedUser,
		'' as [Source]
	FROM
		NotesPositionRelations npr
	INNER JOIN
		Notes n
	ON
		n.id = npr.noteid
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
		npr.positionid = @posId
	AND
		(@filterTypeId = -1 OR (nt.ID = @filterTypeId))
	AND
		(@filterSearch = '' OR ([subject] LIKE '%' + @filterSearch + '%' OR body LIKE '%' + @filterSearch + '%' OR updatedAccount.accountname LIKE '%' + @filterSearch + '%' OR createdAccount.accountname LIKE '%' + @filterSearch + '%'))
	AND
		(CanEmpView = 1 OR (CanEmpView = 0 AND CreatedUserID <> @userId))
	ORDER BY
		n.UpdatedDateTime DESC
END

