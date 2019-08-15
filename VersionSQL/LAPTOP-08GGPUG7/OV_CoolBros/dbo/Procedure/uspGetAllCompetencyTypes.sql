/****** Object:  Procedure [dbo].[uspGetAllCompetencyTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllCompetencyTypes](@filterEnabled int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT ct.*, ISNULL(subSetCompetenciesCount.SubCount, 0) AS SubCount, ISNULL(SubSetSubFolders.SubCount, 0) AS SubCountGroups FROM CompetencyTypes ct
    LEFT OUTER JOIN
    (
		SELECT
			t.Id AS TypeId,    
			COUNT(DISTINCT l.CompetencyId) AS SubCount
		FROM
			CompetencyTypes t
		INNER JOIN
			CompetencyGroups g
		ON
			g.TypeId = t.Id AND (g.[Enabled] = 'Y' or @filterEnabled = 0)
		INNER JOIN
			CompetencyList l
		ON
			l.CompetencyGroupId = g.Id
		INNER JOIN
			Competencies c
		ON
			c.Id = l.CompetencyId AND (c.[Enabled] = 'Y' or @filterEnabled = 0)
		GROUP BY t.Id
	) as subSetCompetenciesCount
	ON
		subSetCompetenciesCount.TypeId = ct.Id
	LEFT OUTER JOIN
	(
		SELECT
			t.Id AS TypeId,
			COUNT(DISTINCT g.Id) AS SubCount
		FROM
			CompetencyTypes t
		INNER JOIN
			CompetencyGroups g
		ON
			g.TypeId = t.Id AND (g.[Enabled] = 'Y' or @filterEnabled = 0)
		GROUP BY
			t.Id
	) as SubSetSubFolders
	ON
		SubSetSubFolders.TypeId = ct.Id
	WHERE
		ct.[Enabled] = 'Y' or @filterEnabled = 0
    ORDER BY ct.SortOrder;
END

