/****** Object:  Procedure [dbo].[uspGetSalaryReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSalaryReport](@groupBy varchar(50), @sortBy varchar(50), @statusList varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @statusTable TABLE([status] varchar(max));
	INSERT INTO @statusTable SELECT splitdata FROM fnSplitString(@statusList, ',');

    SELECT
		@sortBy,		
		e.displayname,
		p.title as title,
		epi.positionid,
		epi.id,
		epi.employeeid,
		p.orgunit2 as posorgunit2,
		p.orgunit3 as posorgunit3,
		isnull(e.basesalary, 0.0) as basesalary,
		isnull(e.basesuper, 0.0) as basesuper,
		(isnull(e.CurrentSalaryExtra1, 0.0) + isnull(e.CurrentSalaryExtra2, 0.0) + isnull(e.CurrentSalaryExtra3, 0.0) + isnull(e.CurrentSalaryExtra4, 0.0) + isnull(e.CurrentSalaryExtra5, 0.0)) as extrasalary,
		(isnull(e.CurrentSalaryExtra1, 0.0) + isnull(e.CurrentSalaryExtra2, 0.0) + isnull(e.CurrentSalaryExtra3, 0.0) + isnull(e.CurrentSalaryExtra4, 0.0) + isnull(e.CurrentSalaryExtra5, 0.0) + isnull(e.basesuper, 0.0) + isnull(e.basesalary, 0.0)) as totalsalary
	FROM
		EmployeePosition epi
	INNER JOIN
		Employee e
	ON
		e.id = epi.employeeid
	INNER JOIN
		Position p
	ON
		p.id = epi.positionid
	WHERE
		e.isplaceholder = 0 and e.displayname <> 'vacant' AND (e.Status IN (SELECT [status] FROM @statusTable))
		AND
		epi.positionid = ISNULL((SELECT TOP 1 PositionID FROM EmployeePosition WHERE IsDeleted = 0 AND primaryposition = 'Y' AND EmployeeID = e.id), (SELECT MAX(Positionid) FROM EmployeePosition WHERE Employeeid = e.ID))
	ORDER BY
		CASE @groupBy WHEN 'displayname' THEN e.displayname END asc,
		CASE WHEN @groupBy = 'title' THEN p.title END asc,
		CASE WHEN @groupBy = 'posorgunit2' THEN p.orgunit2 END asc,
		CASE WHEN @groupBy = 'posorgunit3' THEN p.orgunit3 END asc,
		CASE WHEN @sortBy = 'displayname' THEN e.displayname END asc,
		CASE WHEN @sortBy = 'title' THEN p.title END asc,
		CASE WHEN @sortBy = 'division' THEN p.orgunit2 END asc,
		CASE WHEN @sortBy = 'department' THEN p.orgunit3 END asc,
		CASE WHEN @sortBy = 'basesalary' THEN e.basesalary END desc,
		CASE WHEN @sortBy = 'basesuper' THEN e.basesuper END desc,
		CASE WHEN @sortBy = 'extrasalary' THEN (isnull(e.CurrentSalaryExtra1, 0.0) + isnull(e.CurrentSalaryExtra2, 0.0) + isnull(e.CurrentSalaryExtra3, 0.0) + isnull(e.CurrentSalaryExtra4, 0.0) + isnull(e.CurrentSalaryExtra5, 0.0)) END desc,
		CASE WHEN @sortBy = 'totalsalary' THEN (isnull(e.CurrentSalaryExtra1, 0.0) + isnull(e.CurrentSalaryExtra2, 0.0) + isnull(e.CurrentSalaryExtra3, 0.0) + isnull(e.CurrentSalaryExtra4, 0.0) + isnull(e.CurrentSalaryExtra5, 0.0) + isnull(e.basesuper, 0.0) + isnull(e.basesalary, 0.0)) END desc,
		CASE WHEN @sortBy = 'surname' THEN e.surname END asc,
		CASE WHEN @sortBy = 'surname' THEN e.firstname END asc
	
END
