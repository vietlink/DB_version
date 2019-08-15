/****** Object:  Procedure [dbo].[uspGetComplianceScoreDetailsByListID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetComplianceScoreDetailsByListID](@listid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT c.ComplianceScoreType, c.ComplianceScoreRange
	FROM CompetencyList cl
	INNER JOIN Competencies c
	ON c.id = cl.competencyid
	WHERE cl.id = @listid;
END


