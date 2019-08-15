/****** Object:  Procedure [dbo].[uspGetPositionCompetenciesByTypeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionCompetenciesByTypeID](@typeid int, @filterEnabled int = 0, @positionid int = 0, @isCompliance int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		c.[Description] AS Competency,
		g.[Description] AS CompetencyGroup,
		g.Id AS CompetencyGroupId,
		l.Id AS CompetencyListId,
		c.Id AS CompetencyId,
		ISNULL(subset.SubCount, 0) AS EmployeeCount,
		CASE WHEN pcl.Id IS NULL THEN '0' ELSE '1' END AS EmployeeIsCompetent,
		pcl.RankingId as EmployeeCompetencyRankingId,
		pcl.Id,
		pcl.IsMandatory,
		c.[Enabled],
		subDocs.Count as DocumentCount,
		0 as NotesCount,
		c.[Type],
		'' as DateFrom,
		'' as DateTo,
		'' as reference,
		1 as iHaveThis,
		0 as IsPositionCompetency
	FROM
		Competencies c
	INNER JOIN
		CompetencyList l
	ON 
		l.CompetencyId = c.Id
	INNER JOIN
		CompetencyGroups g
	ON
		l.CompetencyGroupId = g.Id
	LEFT OUTER JOIN
		PositionCompetencyList pcl
	ON
		pcl.CompetencyListId = l.Id AND pcl.Positionid = @positionid
	LEFT OUTER JOIN
		(SELECT
			COUNT(*) as Count,
			d.DataID
		FROM
			Documents d
		WHERE
			d.IsDeleted = 0 AND 
			((@isCompliance = 0 AND d.PageType = 'PositionCompetency') OR (@isCompliance = 1 AND d.PageType = 'PositionCompliance'))
		GROUP BY d.DataID
	) as subDocs
	ON subDocs.DataID = pcl.Id
	LEFT OUTER JOIN	
		(SELECT
			c.Id AS CompetencyId,
			COUNT(DISTINCT pcl.Positionid) AS SubCount
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
		) AS SubSet
	ON
		Subset.CompetencyId = c.Id
	WHERE
		g.TypeId = @typeid AND (c.[Enabled] = 'Y' OR @filterEnabled = 0)AND ((c.[Type] = 2 AND @isCompliance = 1) OR ((c.[Type] = 1 OR c.[Type] = 0) AND @isCompliance = 0) OR @isCompliance = 2)
	ORDER BY c.[Description];
END

