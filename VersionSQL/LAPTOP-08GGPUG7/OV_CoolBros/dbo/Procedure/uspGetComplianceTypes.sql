/****** Object:  Procedure [dbo].[uspGetComplianceTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetComplianceTypes]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT ct.id, ct.code, ct.[description], ct.sortorder, ct.[enabled], isnull(ct.issubcategexists, 0) issubcategexists, ISNULL(subSetCompetenciesCount.SubCount, 0) AS SubCount, ISNULL(subSetCompetenciesCount.SubCountGroups, 0) AS SubCountGroups FROM CompetencyTypes ct
	LEFT OUTER JOIN
    (
		SELECT
			t.Id AS TypeId,    
			COUNT(DISTINCT l.CompetencyId) AS SubCount,
			COUNT(DISTINCT g.Id) AS SubCountGroups
		FROM
			CompetencyTypes t
		INNER JOIN
			CompetencyGroups g
		ON
			g.TypeId = t.Id AND (g.[Enabled] = 'Y' )
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
		GROUP BY t.Id
	) as subSetCompetenciesCount
	ON
		subSetCompetenciesCount.TypeId = ct.Id
	WHERE ct.id IN
	(
		SELECT distinct ct.id FROM CompetencyTypes ct
		INNER JOIN CompetencyGroups cg ON cg.TypeId = ct.id
		INNER JOIN CompetencyList cl ON cl.CompetencyGroupId = cg.id
		INNER JOIN Competencies c ON c.id = cl.CompetencyId
		WHERE c.[Type] = 2 AND ct.[Enabled] = 'Y'
	)
	 ORDER BY SortOrder
END


