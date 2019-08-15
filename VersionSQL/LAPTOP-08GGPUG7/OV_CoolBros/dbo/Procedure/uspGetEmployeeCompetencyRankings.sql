/****** Object:  Procedure [dbo].[uspGetEmployeeCompetencyRankings]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeCompetencyRankings](@filterEnabled int = 0, @excludeNonPosTypes int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		*
	FROM	
		EmployeeCompetencyRankings
	WHERE
		(IsEnabled = 1 OR @filterEnabled = 0)
		AND
		(ExclFromPosition = 0 OR @excludeNonPosTypes = 0)
	ORDER BY RankingIndex;
END

