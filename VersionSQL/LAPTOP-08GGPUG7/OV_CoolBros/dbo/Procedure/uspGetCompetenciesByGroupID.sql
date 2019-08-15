/****** Object:  Procedure [dbo].[uspGetCompetenciesByGroupID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompetenciesByGroupID](@groupid int, @filterEnabled int = 0, @employeeId int = 0, @isCompliance int = 0, @positionid int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		c.[Description] AS Competency,
		g.[Description] AS CompetencyGroup,
		g.Id AS CompetencyGroupId,
		l.Id AS CompetencyListId,
		c.Id AS CompetencyId,
		ISNULL(SubSet.SubCount, 0) AS EmployeeCount,
		CASE WHEN ecl.Id IS NULL THEN '0' ELSE '1' END AS EmployeeIsCompetent,
		ecl.EmployeeCompetencyRankingId,
		ecl.Id,
		c.[Enabled],
		subDocs.Count as DocumentCount,
		isnull(subNotes.Count, 0) as NotesCount,
		c.Type,
		ecl.DateFrom,
		ecl.DateTo,
		CASE WHEN pcl.Id IS NULL THEN '0' ELSE '1' END AS IsPositionCompetency,
		ISNULL(pcr.RankingIndex, '0') AS PositionRankingIndex,
		ISNULL(ecr.RankingIndex, '0') AS EmployeeRankingIndex,
		ecl.iHaveThis,
		isnull(ecl.Reference, '') as Reference,
		ISNULL(SubSetPos.SubCount, 0) AS PositionCount
	FROM
		Competencies c
	INNER JOIN
		CompetencyList l
	ON 
		l.CompetencyId = c.Id
	LEFT OUTER JOIN
		PositionCompetencyList pcl
	ON
		pcl.CompetencyListId = l.Id AND pcl.PositionId = @positionId
	LEFT OUTER JOIN
		EmployeeCompetencyRankings pcr
	ON
		pcl.RankingId = pcr.ID
	INNER JOIN
		CompetencyGroups g
	ON
		l.CompetencyGroupId = g.Id
	LEFT OUTER JOIN
		EmployeeCompetencyList ecl
	ON
		ecl.CompetencyListId = l.Id AND ecl.Employeeid = @employeeId
	LEFT OUTER JOIN
		EmployeeCompetencyRankings ecr
	ON
		ecl.EmployeeCompetencyRankingId = ecr.Id
	LEFT OUTER JOIN
		(SELECT
			COUNT(*) as Count,
			d.DataID
		FROM
			Documents d
		WHERE
			d.IsDeleted = 0 AND
			((@isCompliance = 0 AND d.PageType = 'Competency') OR (@isCompliance = 1 AND d.PageType = 'Compliance'))
		GROUP BY d.DataID
	) as subDocs
	ON subDocs.DataID = ecl.Id

	LEFT OUTER JOIN
		(SELECT
			COUNT(*) as Count,
			n.CompetencyID
		FROM
			NotesCompetencyRelations n
		GROUP BY n.CompetencyID
	) as subNotes
	ON subNotes.CompetencyID = ecl.Id

	LEFT OUTER JOIN	
		(SELECT
			c.Id AS CompetencyId,
			COUNT(DISTINCT ecl.Employeeid) AS SubCount
		FROM
			Competencies c
		INNER JOIN
			CompetencyList l
		ON
			l.CompetencyId = c.Id
		INNER JOIN
			EmployeeCompetencyList ecl
		ON
			ecl.iHaveThis = 1 AND ecl.CompetencyListId = l.Id
		INNER JOIN
			Employee E
		ON
			E.id = ecl.Employeeid
		WHERE
			e.IsDeleted = 0
		GROUP BY
			c.Id
		) AS SubSet
	ON
		Subset.CompetencyId = c.Id
	LEFT OUTER JOIN	
		(SELECT
			c.Id AS CompetencyId,
			COUNT(DISTINCT pcl.PositionId) AS SubCount
		FROM
			Competencies c
		INNER JOIN
			CompetencyList l
		ON
			l.CompetencyId = c.Id
		INNER JOIN
			PositionCompetencyList pcl
		ON
			pcl.CompetencyListId = l.Id
		GROUP BY
			c.Id
		) AS SubSetPos
	ON
		SubSetPos.CompetencyId = c.Id
	WHERE
		g.Id = @groupid AND (c.[Enabled] = 'Y' OR @filterEnabled = 0) AND ((c.[Type] = 2 AND @isCompliance = 1) OR ((c.[Type] = 1 OR c.[Type] = 0) AND @isCompliance = 0) OR @isCompliance = 2)
	ORDER BY c.[Description];
END

