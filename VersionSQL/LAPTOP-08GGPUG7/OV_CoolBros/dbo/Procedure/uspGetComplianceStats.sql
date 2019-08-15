/****** Object:  Procedure [dbo].[uspGetComplianceStats]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetComplianceStats](@employeeId int, @expDays int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @validCount int = 0;

	SELECT
		@validCount = count(*)
	FROM
		EmployeeCompetencyList ecl
	INNER JOIN
		CompetencyList cl
	ON
		cl.id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	WHERE
		ecl.Employeeid = @employeeId AND c.[Type] = 2 AND ecl.IsMandatory = 1
		AND
		((cast(DATEADD(d,0,DATEDIFF(d,0,GETDATE())) as date))  BETWEEN DateFrom AND DateTo) AND NOT (DATEADD(day, @expDays, (cast(DATEADD(d,0,DATEDIFF(d,0,GETDATE())) as date)) ) NOT BETWEEN DateFrom AND DateTo)

	DECLARE @expireSoonCount int = 0;
	SELECT
		@expireSoonCount = count(*)
	FROM
		EmployeeCompetencyList ecl
	INNER JOIN
		CompetencyList cl
	ON
		cl.id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	WHERE
		ecl.Employeeid = @employeeId AND c.[Type] = 2 AND ecl.IsMandatory = 1
		AND
		(((cast(DATEADD(d,0,DATEDIFF(d,0,GETDATE())) as date)) BETWEEN DateFrom AND DateTo) AND (DATEADD(day, @expDays, (cast(DATEADD(d,0,DATEDIFF(d,0,GETDATE())) as date)) ) NOT BETWEEN DateFrom AND DateTo))

	DECLARE @expiredCount int = 0;
	SELECT
		@expiredCount = count(*)
	FROM
		EmployeeCompetencyList ecl
	INNER JOIN
		CompetencyList cl
	ON
		cl.id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	WHERE
		ecl.Employeeid = @employeeId AND c.[Type] = 2 AND ecl.IsMandatory = 1
		AND
		(((cast(DATEADD(d,0,DATEDIFF(d,0,GETDATE())) as date))  NOT BETWEEN DateFrom AND DateTo) OR DateFrom IS NULL)


	DECLARE @validCountOptional int = 0;

	SELECT
		@validCountOptional = count(*)
	FROM
		EmployeeCompetencyList ecl
	INNER JOIN
		CompetencyList cl
	ON
		cl.id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	WHERE
		ecl.Employeeid = @employeeId AND c.[Type] = 2 AND ecl.IsMandatory = 0
		AND
		((cast(DATEADD(d,0,DATEDIFF(d,0,GETDATE())) as date))  BETWEEN DateFrom AND DateTo) AND NOT (DATEADD(day, @expDays, (cast(DATEADD(d,0,DATEDIFF(d,0,GETDATE())) as date)) ) NOT BETWEEN DateFrom AND DateTo)

	DECLARE @expireSoonCountOptional int = 0;
	SELECT
		@expireSoonCountOptional = count(*)
	FROM
		EmployeeCompetencyList ecl
	INNER JOIN
		CompetencyList cl
	ON
		cl.id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	WHERE
		ecl.Employeeid = @employeeId AND c.[Type] = 2 AND ecl.IsMandatory = 0
		AND
		(((cast(DATEADD(d,0,DATEDIFF(d,0,GETDATE())) as date)) BETWEEN DateFrom AND DateTo) AND (DATEADD(day, @expDays, (cast(DATEADD(d,0,DATEDIFF(d,0,GETDATE())) as date)) ) NOT BETWEEN DateFrom AND DateTo))

	DECLARE @expiredCountOptional int = 0;
	SELECT
		@expiredCountOptional = count(*)
	FROM
		EmployeeCompetencyList ecl
	INNER JOIN
		CompetencyList cl
	ON
		cl.id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	WHERE
		ecl.Employeeid = @employeeId AND c.[Type] = 2 AND ecl.IsMandatory = 0
		AND
		(((cast(DATEADD(d,0,DATEDIFF(d,0,GETDATE())) as date))  NOT BETWEEN DateFrom AND DateTo) OR DateFrom IS NULL)

	SELECT
		ISNULL(@validCount, 0) as ValidCount,
		ISNULL(@expireSoonCount, 0) as ExpireSoonCount,
		ISNULL(@expiredCount, 0) as ExpiredCount,
		ISNULL(@validCountOptional, 0) as ValidCountOptional,
		ISNULL(@expireSoonCountOptional, 0) as ExpireSoonCountOptional,
		ISNULL(@expiredCountOptional, 0) as ExpiredCountOptional
END

