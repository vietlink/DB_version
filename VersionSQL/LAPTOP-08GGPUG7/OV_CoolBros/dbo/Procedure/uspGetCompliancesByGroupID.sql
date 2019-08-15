/****** Object:  Procedure [dbo].[uspGetCompliancesByGroupID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompliancesByGroupID](@groupId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT cl.id as listid, c.*
	FROM Competencies c
	INNER JOIN
	CompetencyList cl
	ON cl.CompetencyId = c.id
	INNER JOIN
	CompetencyGroups cg
	ON cg.id = cl.CompetencyGroupId
	WHERE c.[Type] = 2 AND cg.ID = @groupId
END


