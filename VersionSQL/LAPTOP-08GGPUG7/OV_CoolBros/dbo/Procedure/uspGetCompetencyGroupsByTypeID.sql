/****** Object:  Procedure [dbo].[uspGetCompetencyGroupsByTypeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompetencyGroupsByTypeID](@typeid int, @filterEnabled int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT g.*, ISNULL(SubSet.SubCount, 0) as SubCount FROM CompetencyGroups g
    LEFT OUTER JOIN (
		SELECT
			cg.Id AS GroupId,
			COUNT(DISTINCT l.CompetencyId) AS SubCount
		FROM
			CompetencyGroups cg
		INNER JOIN
			CompetencyList l
		ON
			l.CompetencyGroupId = cg.Id
		INNER JOIN
			Competencies c
		ON
			c.Id = l.CompetencyId AND (c.[Enabled] = 'Y' OR @filterEnabled = 0)
		GROUP BY cg.Id
	) AS SubSet
	ON
		SubSet.GroupId = g.Id		
    WHERE TypeId = @typeid AND (g.[Enabled] = 'Y' OR @filterEnabled = 0)
    ORDER BY SortOrder;
END

