/****** Object:  Procedure [dbo].[uspGetTerminationReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTerminationReport](@days int, @sortBy varchar(50), @groupBy varchar(50))
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
		e.termination,
		e.TerminationReason,
		e.RegrettableLoss,
		ep.id,
		p.id as positionid,
		e.id as employeeid
	FROM
		Employee e
	INNER JOIN
		(
			SELECT max(id) as id, employeeid FROM EmployeePosition GROUP BY employeeId
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
		ep.primaryposition = 'y' and ep.isdeleted = 0 
		and (DATEDIFF(day, convert(datetime,e.termination) , convert(datetime,getdate())) < @days 
		AND DATEDIFF(day, convert(datetime,e.termination), convert(datetime,getdate())) >= 0) 
		AND e.displayname <> 'Vacant' AND E.status <> 'Deleted' --AND ep.primaryposition = 'Y'
	ORDER BY
		CASE @groupBy WHEN 'displayname' THEN e.displayname END asc,
		CASE WHEN @groupBy = 'positiontitle' THEN p.title END asc,
		CASE WHEN @groupBy = 'division' THEN isnull(p.orgunit2, '') END asc,
		CASE WHEN @groupBy = 'department' THEN isnull(p.orgunit3, '') END asc,
		CASE WHEN @groupBy = 'termination' THEN e.termination END desc,
		CASE WHEN @groupBy = 'regrettableloss' THEN e.regrettableloss END asc,
		CASE WHEN @groupBy = 'terminationreason' THEN e.terminationreason END asc,
		CASE WHEN @sortBy = 'displayname' THEN e.displayname END asc,
		CASE WHEN @sortBy = 'termination' THEN e.termination END desc,
		CASE WHEN @sortBy = 'positiontitle' THEN p.title END asc,
		CASE WHEN @sortBy = 'division' THEN isnull(p.orgunit2, '') END asc,
		CASE WHEN @sortBy = 'department' THEN isnull(p.orgunit3, '') END asc,
		CASE WHEN @sortBy = 'regrettableloss' THEN e.regrettableloss END asc,
		CASE WHEN @sortBy = 'terminationreason' THEN e.terminationreason END asc,
		CASE WHEN @sortBy = 'surname' THEN e.surname END asc,
		CASE WHEN @sortBy = 'surname' THEN e.firstname END asc
END
