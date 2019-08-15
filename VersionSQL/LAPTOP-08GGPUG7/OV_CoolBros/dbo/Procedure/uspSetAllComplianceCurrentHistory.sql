/****** Object:  Procedure [dbo].[uspSetAllComplianceCurrentHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetAllComplianceCurrentHistory]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @eclId int;
	DECLARE @competencyListId int;
	DECLARE @employeeId int;

	DECLARE 
		complianceCursor
	CURSOR FOR SELECT
		ecl.id,
		ecl.CompetencyListId,
		ecl.Employeeid
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
		c.[Type] = 2 -- compliance

	OPEN complianceCursor;

	FETCH NEXT FROM
		complianceCursor
	INTO
		@eclId, @competencyListId, @employeeId

	
	WHILE @@FETCH_STATUS = 0 BEGIN
		EXEC dbo.uspSetCurrentComplianceHistory @eclId, @competencyListId, @employeeId
	
		FETCH NEXT FROM
			complianceCursor
		INTO
			@eclId, @competencyListId, @employeeId
	END

	CLOSE complianceCursor;
	DEALLOCATE complianceCursor;
END


