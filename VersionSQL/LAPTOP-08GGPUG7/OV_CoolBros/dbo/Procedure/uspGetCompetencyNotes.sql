/****** Object:  Procedure [dbo].[uspGetCompetencyNotes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetCompetencyNotes](@competencyEmpListId int, @userId int, @filterTypeId int, @filterSearch varchar(max))
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
		CanEmpView,
		CreatedDateTime,
		UpdatedDateTime,
		CreatedUserID,
		createdAccount.accountname as CreatedUser,
		isnull(updatedAccount.accountname, '') as UpdatedUser,
		c.[Description] as [Source]
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
	INNER JOIN
		EmployeeCompetencyList ecl
	ON
		ecl.Id = @competencyEmpListId
	INNER JOIN
		CompetencyList cl
	ON
		cl.id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	INNER JOIN
		Employee e
	ON
		e.id = ecl.Employeeid
	LEFT OUTER JOIN
		[User] u
	ON
		u.displayname = e.displayname
	WHERE
		ncr.CompetencyID = @competencyEmpListId
	AND
		(@filterTypeId = -1 OR (nt.ID = @filterTypeId))
	AND
		(@filterSearch = '' OR ([subject] LIKE '%' + @filterSearch + '%' OR body LIKE '%' + @filterSearch + '%' OR updatedAccount.accountname LIKE '%' + @filterSearch + '%' OR createdAccount.accountname LIKE '%' + @filterSearch + '%'))
	AND
		(CanEmpView = 1 OR (CanEmpView = 0 AND ISNULL(u.id,0) <> @userId))
	ORDER BY
		n.UpdatedDateTime DESC
END


