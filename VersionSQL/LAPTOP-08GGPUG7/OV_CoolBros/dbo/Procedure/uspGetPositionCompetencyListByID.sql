/****** Object:  Procedure [dbo].[uspGetPositionCompetencyListByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionCompetencyListByID](@posid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT pcl.id, pcl.PositionId, pcl.CompetencyListId, pcl.IsMandatory, r.RankingIndex as RankingId FROM PositionCompetencyList pcl 
	LEFT OUTER JOIN
	EmployeeCompetencyRankings r
	ON r.Id = pcl.RankingId
	WHERE PositionId = @posid
END

