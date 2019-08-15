/****** Object:  Procedure [dbo].[uspGetComplianceGroupsByTypeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetComplianceGroupsByTypeID](@typeid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT cg.*, ISNULL(subSetCompetenciesCount.SubCount, 0) AS SubCount FROM CompetencyGroups cg
	LEFT OUTER JOIN
    (
		SELECT
			g.Id AS Groupid,    
			COUNT(DISTINCT l.CompetencyId) AS SubCount
		FROM
			CompetencyGroups g
		INNER JOIN
			CompetencyList l
		ON
			l.CompetencyGroupId = g.Id
		INNER JOIN
			Competencies c
		ON
			c.Id = l.CompetencyId AND (c.[Enabled] = 'Y' )
		WHERE
			c.[Type] = 2
		GROUP BY g.Id
	) as subSetCompetenciesCount
	ON
		subSetCompetenciesCount.GroupID = cg.Id
	WHERE id IN
	(
		SELECT distinct cg.id FROM CompetencyTypes ct
		INNER JOIN CompetencyGroups cg ON cg.TypeId = ct.id
		INNER JOIN CompetencyList cl ON cl.CompetencyGroupId = cg.id
		INNER JOIN Competencies c ON c.id = cl.CompetencyId
		WHERE c.[Type] = 2 AND ct.id = @typeid AND cg.[Enabled] = 'Y'
	)
	ORDER BY SortOrder, [Description]

END


