/****** Object:  Procedure [dbo].[uspGetEmployeeComplianceHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeComplianceHistory](@empid int, @listid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ech.*, ecl.IsPositionRequirement as IsPositionRequirementEcl FROM EmployeeComplianceHistory ech 
	LEFT OUTER JOIN
	EmployeeCompetencyList ecl
	ON
	ech.EmployeeCompetencyListID = ecl.id
	WHERE ech.EmployeeID = @empid AND ech.ListID = @listid
	ORDER BY isnull(ech.dateto, ech.nolongerrequireddate) desc
END


