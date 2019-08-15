/****** Object:  Procedure [dbo].[uspGetCompetencyDetailsByListAndEmployeeId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompetencyDetailsByListAndEmployeeId](@listid int, @employeeId int = null)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		c.[Description] AS Competency,
		cg.Id AS CompetencyGroupId,
		cg.[Description] AS CompetencyGroup,
		ecl.EmployeeCompetencyRankingId,
		c.[Type],
		ecl.DateFrom,
		ecl.DateTo,
		ecl.Reference
	FROM
		Competencies c
	INNER JOIN
		CompetencyList cl
	ON
		cl.CompetencyId = c.Id
	INNER JOIN
		CompetencyGroups cg
	ON 
		cl.CompetencyGroupId = cg.Id
	LEFT OUTER JOIN
		EmployeeCompetencyList ecl
	ON
		ecl.CompetencyListId = cl.Id AND ecl.Employeeid = @employeeId
	WHERE
		cl.Id = @listid
END

