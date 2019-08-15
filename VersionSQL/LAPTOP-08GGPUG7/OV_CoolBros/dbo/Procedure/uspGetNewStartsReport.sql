/****** Object:  Procedure [dbo].[uspGetNewStartsReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetNewStartsReport](@days int, @sortBy varchar(50), @groupBy varchar(50), @futureStarters bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		e.displayname,
		p.title as positiontitle,
		e.commencement,
		p.orgunit2 as Division,
		p.orgunit3 as Department,
		e.picture as Picture,
		p.id as positionid,
		ep.id,
		e.id as employeeid
	FROM
		Employee e
	INNER JOIN
		(
			SELECT max(id) as id, employeeid FROM EmployeePosition WHERE IsDeleted = 0 GROUP BY employeeId
		) as rs
	ON
		e.id = rs.employeeid
	INNER JOIN
		EmployeePosition ep
	ON
		ep.id = rs.id
	INNER JOIN
		Position p
	ON
		p.id = ep.positionid
	WHERE
		(DATEDIFF(day, e.commencement, GETDATE()) <= @days AND (@futureStarters = 1 OR (@futureStarters = 0 AND DATEDIFF(day, e.commencement, GETDATE()) >= 0))) AND (e.[status] <> 'deleted') and e.displayname <> 'Vacant' AND e.IsPlaceholder = 0
	ORDER BY
		CASE @groupBy WHEN 'displayname' THEN e.displayname END asc,
		CASE WHEN @groupBy = 'positiontitle' THEN p.title END asc,
		CASE WHEN @groupBy = 'division' THEN p.orgunit2 END asc,
		CASE WHEN @groupBy = 'department' THEN p.orgunit3 END asc,
		CASE WHEN @groupBy = 'commencement' THEN e.commencement END desc,
		CASE WHEN @sortBy = 'displayname' THEN e.displayname END asc,
		CASE WHEN @sortBy = 'commencement' THEN e.commencement END desc,
		CASE WHEN @sortBy = 'positiontitle' THEN p.title END asc,
		CASE WHEN @sortBy = 'division' THEN p.orgunit2 END asc,
		CASE WHEN @sortBy = 'department' THEN p.orgunit3 END asc,
		CASE WHEN @sortBy = 'surname' THEN e.surname END asc,
		CASE WHEN @sortBy = 'surname' THEN e.firstname END asc
END
