/****** Object:  Procedure [dbo].[uspGetCompetencyTypeById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompetencyTypeById](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @subCount int;
	DECLARE @subCountGroups int;
	
	SELECT
		@subCount = COUNT(DISTINCT c.Id)
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
	WHERE
		g.TypeId = @id	
		
	SELECT
		@SubCountGroups = COUNT(DISTINCT g.Id)
	FROM
		CompetencyGroups g
	WHERE
		g.TypeId = @id;
		
		
    SELECT c.*, @subCount AS SubCount, @subCountGroups AS SubCountGroups FROM CompetencyTypes c WHERE Id = @id;
END

