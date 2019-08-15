/****** Object:  Procedure [dbo].[uspGetPositionComplianceDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionComplianceDetails](@posid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT pcl.*, rsdocuments.documentcount, c.id as complianceid, cg.id as groupid,
	cg.[Description] as [group], c.[Description] as compliance
	FROM PositionCompetencyList pcl
	INNER JOIN
	CompetencyList cl
	ON cl.id = pcl.CompetencyListId
	INNER JOIN
	Competencies c
	ON c.id = cl.CompetencyId
	INNER JOIN
	CompetencyGroups cg
	ON cg.id = cl.CompetencyGroupId
	CROSS APPLY(
		SELECT isnull(COUNT(*), 0) as documentcount FROM Documents WHERE pagetype = 'PositionCompliance' AND dataid = pcl.id AND IsDeleted = 0
	) rsdocuments
	WHERE c.[Type] = 2 AND pcl.positionid = @posid
	ORDER BY cg.[SortOrder], cg.[Description], c.SortOrder, c.[Description]
END


