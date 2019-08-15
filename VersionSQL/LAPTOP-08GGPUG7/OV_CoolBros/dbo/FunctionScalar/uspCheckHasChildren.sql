/****** Object:  Function [dbo].[uspCheckHasChildren]    Committed by VersionSQL https://www.versionsql.com ******/


CREATE FUNCTION [dbo].[uspCheckHasChildren](@EmpPosId int)
RETURNs INT
AS
BEGIN
	DECLARE @employeeCount int = 0;
	DECLARE @vacantCount int = 0;
	DECLARE @totalCount int = 0;

	----- Get Vacant count ----

	SELECT
		@vacantCount = COUNT(ep.id)
	FROM
		Position p
	INNER JOIN
		PositionGrouplessHierarchy pgh
	ON
		pgh.PositionID = p.ID
	INNER JOIN
		EmployeePosition ep
	ON
		p.id = ep.positionid AND ep.ExclFromSubordCount = 'N'
	INNER JOIN
		Employee e
	ON
		e.id = ep.employeeid
	WHERE
		pgh.parentid = (SELECT ISNULL(positionid, 0) FROM EmployeePosition WHERE id = @EmpPosID) and p.IsUnassigned = 0
	AND
		p.isplaceholder = 0 and e.Identifier = 'Vacant' AND ep.IsDeleted = 0 AND p.IsDeleted = 0

	----- Get Distinct Employee count ----

	SELECT
		@employeeCount = COUNT(DISTINCT e.id)
	FROM
		Position p
	INNER JOIN
		PositionGrouplessHierarchy pgh
	ON
		pgh.PositionID = p.ID
	INNER JOIN
		EmployeePosition ep
	ON
		p.id = ep.positionid AND ep.ExclFromSubordCount = 'N'
	INNER JOIN
		Employee e
	ON
		e.id = ep.employeeid
	INNER JOIN
		[status] s
	ON
		s.[Description] = e.[status]
	WHERE
		pgh.parentid = (SELECT ISNULL(positionid, 0) FROM EmployeePosition WHERE id = @EmpPosID)
	AND
		p.isplaceholder = 0 and s.IsVisibleChart = 1 AND e.Identifier <> 'Vacant' AND e.IsDeleted = 0 AND p.IsDeleted = 0 AND ep.IsDeleted = 0 and p.IsUnassigned = 0

	RETURN (@vacantCount + @employeeCount)
END

