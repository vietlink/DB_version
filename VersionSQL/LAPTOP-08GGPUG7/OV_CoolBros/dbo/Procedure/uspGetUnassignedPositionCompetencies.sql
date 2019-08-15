/****** Object:  Procedure [dbo].[uspGetUnassignedPositionCompetencies]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetUnassignedPositionCompetencies](@posid int, @empid int, @filterCompliances int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT 
		pcl.CompetencyListId
	FROM
		PositionCompetencyList pcl
	INNER JOIN	
		CompetencyList cl
	ON
		cl.Id = pcl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	WHERE ((c.Type <> 2 AND @filterCompliances = 0) OR (c.[Type] = 2 AND @filterCompliances = 1)) 
	AND pcl.PositionId = @posid AND cl.Id NOT IN
	(
		SELECT
			ecl.[CompetencyListId]
		FROM
			EmployeeCompetencyList ecl
		WHERE
			ecl.Employeeid = @empid
	)
    
END


