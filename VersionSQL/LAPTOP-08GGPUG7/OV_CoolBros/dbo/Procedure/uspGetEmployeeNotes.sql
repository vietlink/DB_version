/****** Object:  Procedure [dbo].[uspGetEmployeeNotes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeNotes](@empId int, @userId int, @filterTypeId int, @filterSearch varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM (
    SELECT
		ner.Id,
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
		ner.employeeid = @empId
	AND
		(@filterTypeId = -1 OR (nt.ID = @filterTypeId))
	AND
		(@filterSearch = '' OR ([subject] LIKE '%' + @filterSearch + '%' OR body LIKE '%' + @filterSearch + '%'OR updatedAccount.accountname LIKE '%' + @filterSearch + '%' OR createdAccount.accountname LIKE '%' + @filterSearch + '%'))
	AND
		(CanEmpView = 1 OR (CanEmpView = 0 AND ISNULL(EmployeeUserID, 0) <> @userId))
	--ORDER BY
	--	n.UpdatedDateTime DESC

	UNION ALL

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
		EmployeeCompetencyList ecl
	ON
		ecl.id = ncr.competencyid
	INNER JOIN
		CompetencyList cl
	ON
		cl.Id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
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
		ecl.employeeid = @empId
	AND
		(@filterTypeId = -1 OR (nt.ID = @filterTypeId))
	AND
		(@filterSearch = '' OR ([subject] LIKE '%' + @filterSearch + '%' OR body LIKE '%' + @filterSearch + '%'OR updatedAccount.accountname LIKE '%' + @filterSearch + '%' OR createdAccount.accountname LIKE '%' + @filterSearch + '%'))
	AND
		(CanEmpView = 1 OR (CanEmpView = 0 AND ISNULL(EmployeeUserID, 0) <> @userId))
	) as rs
	ORDER BY
		rs.UpdatedDateTime DESC
END

