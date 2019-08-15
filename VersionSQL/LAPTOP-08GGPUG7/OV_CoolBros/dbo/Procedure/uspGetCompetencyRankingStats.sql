/****** Object:  Procedure [dbo].[uspGetCompetencyRankingStats]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompetencyRankingStats](@positionId int, @employeeId int)
AS
BEGIN
	DECLARE @positionCount int = 0;
	DECLARE @totalPosRating int = 0;

	SELECT
		@positionCount = COUNT(*),
		@totalPosRating = SUM(ISNULL(cr.[RankingIndex], 0))
	FROM
		PositionCompetencyList pcl
	INNER JOIN
		CompetencyList cl
	ON
		cl.id = pcl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	LEFT OUTER JOIN
		EmployeeCompetencyRankings cr
	ON
		cr.Id = pcl.RankingId
	WHERE
		pcl.PositionId = @positionId AND [type] = 1

	DECLARE @totalEmpRating int = 0;

	SELECT
		@totalEmpRating = SUM(ecr.RankingIndex)
	FROM
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
		EmployeeCompetencyRankings ecr
	ON	
		ecr.Id = ecl.EmployeeCompetencyRankingId
	WHERE
		cl.Id IN (
			SELECT
				CompetencyListId
			FROM
				PositionCompetencyList
			WHERE
				PositionId = @positionId
			)
		AND c.[Type] = 1 AND ecl.Employeeid = @employeeId

	SELECT
		ISNULL(cast(@totalPosRating as float) / cast(@positionCount as float), 0) as totalPosRanking,
		ISNULL(cast(@totalEmpRating as float) / cast(@positionCount as float), 0) as totalEmpRating
END


