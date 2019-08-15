/****** Object:  Function [dbo].[fnGetCompletedCompetencyPercent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetCompletedCompetencyPercent](@positionId int, @employeeId int)
RETURNS float
AS
BEGIN
	DECLARE @positionCount int = 0;
	SELECT 
		@positionCount = COUNT(*) 
	FROM
		PositionCompetencyList pcl
	INNER JOIN
		CompetencyList cl 
	ON
		pcl.CompetencyListId = cl.id
	INNER JOIN
		Competencies c
	ON 
		c.id = cl.CompetencyId
	WHERE
		pcl.PositionId = @positionId AND c.[Type] <> 2

	DECLARE @setCount int = 0;
	SELECT @setCount = COUNT(*) FROM
		EmployeeCompetencyList ecl
	INNER JOIN
		CompetencyList cl
	ON 
		cl.Id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON 
		c.id = cl.CompetencyId
	INNER JOIN
		PositionCompetencyList pcl
	ON 
		pcl.CompetencyListId = cl.Id
	LEFT OUTER JOIN
		EmployeeCompetencyRankings ecr
	ON 
		ecr.id = ecl.EmployeeCompetencyRankingId
	WHERE 
		ecl.EmployeeId = @employeeId AND pcl.PositionId = @positionId AND c.[Type] <> 2
		AND
		((c.[Type] = 0) OR
		(c.[Type] = 1 AND ecr.id IS NOT NULL))
	
	IF @positionCount > 0 BEGIN
		RETURN CAST((100 * @setCount) as float) / cast(@positionCount as float)
	END

	RETURN 0;

END


