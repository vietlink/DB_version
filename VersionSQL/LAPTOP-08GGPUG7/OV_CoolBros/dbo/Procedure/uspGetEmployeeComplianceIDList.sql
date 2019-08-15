/****** Object:  Procedure [dbo].[uspGetEmployeeComplianceIDList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeComplianceIDList](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT cl.id as listid FROM EmployeeCompetencyList ecl
	INNER JOIN
	CompetencyList cl
	ON cl.id = ecl.CompetencyListId
	INNER JOIN
	Competencies c
	ON c.id = cl.CompetencyId
	WHERE c.[Type] = 2 AND ecl.Employeeid = @empid;
END


