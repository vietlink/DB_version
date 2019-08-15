/****** Object:  Procedure [dbo].[uspCreateEmployeeComplianceRequirements]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateEmployeeComplianceRequirements](@posid int, @listid int, @updateddate datetime, @updatedby varchar(100), @ismandatory bit, @employeeid int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @empId int = 0;
	DECLARE newItemsCursor CURSOR FOR
	SELECT
		ep.employeeid
	FROM
		EmployeePosition ep
	INNER JOIN
		Employee e
	ON
		e.id = ep.employeeid
	LEFT OUTER JOIN
		EmployeeCompetencyList ecl
	ON
		ecl.employeeid = e.id and ecl.CompetencyListId = @listid
	WHERE
		ep.PositionID = @posid AND ecl.Id IS NULL
		AND ep.IsDeleted = 0 AND e.IsDeleted = 0 AND e.identifier <> 'vacant'
		AND (@employeeid = 0 OR (@employeeid = ep.employeeid))

	OPEN newItemsCursor;

	FETCH NEXT FROM newItemsCursor INTO
		@empId;

	WHILE @@FETCH_STATUS = 0  
	BEGIN
		INSERT INTO EmployeeCompetencyList(employeeid, CompetencyListId, iHaveThis, IsPositionRequirement, ismandatory)
			VALUES(@empId, @listid, 1, 1, @ismandatory)
		INSERT INTO EmployeeComplianceHistory(employeeid, listid, CreatedDate, CreatedBy, UpdatedDate, UpdatedBy, EmployeeCompetencyListID, ismandatory, IsPositionRequirement, ispositionmandatory)
			VALUES(@empId, @listid, @updateddate, @updatedby, @updateddate, @updatedby, @@IDENTITY, @ismandatory, 1, @ismandatory)

		FETCH NEXT FROM newItemsCursor INTO
			@empId;
	END

	CLOSE newItemsCursor;  
	DEALLOCATE newItemsCursor;  

	-- update the existing
	UPDATE ecl
		SET ecl.IsPositionRequirement = 1
	FROM
		EmployeePosition ep
	INNER JOIN
		Employee e
	ON
		e.id = ep.employeeid
	LEFT OUTER JOIN
		EmployeeCompetencyList ecl
	ON
		ecl.employeeid = e.id and ecl.CompetencyListId = @listid
	WHERE
		ep.PositionID = @posid AND ecl.Id IS NOT NULL
		AND ep.IsDeleted = 0 AND e.IsDeleted = 0

	UPDATE ech
		SET ech.ispositionrequirement = 1
	FROM
		EmployeePosition ep
	INNER JOIN
		Employee e
	ON
		e.id = ep.employeeid
	INNER JOIN
		EmployeeCompetencyList ecl
	ON
		ecl.employeeid = e.id and ecl.CompetencyListId = @listid
	INNER JOIN
		EmployeeComplianceHistory ech
	ON
		ech.EmployeeCompetencyListID = ecl.id
	WHERE
		ep.PositionID = @posid AND ep.IsDeleted = 0 AND e.IsDeleted = 0
END


