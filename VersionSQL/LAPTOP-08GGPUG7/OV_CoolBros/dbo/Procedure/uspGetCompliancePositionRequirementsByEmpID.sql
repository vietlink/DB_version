/****** Object:  Procedure [dbo].[uspGetCompliancePositionRequirementsByEmpID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompliancePositionRequirementsByEmpID](@empId int, @listId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT pcl.* FROM EmployeePosition ep
		INNER JOIN Position p ON p.id = ep.positionid 
		INNER JOIN PositionCompetencyList pcl ON pcl.PositionId = p.id
		INNER JOIN CompetencyList _cl ON _cl.id = pcl.CompetencyListId
		WHERE ep.employeeid = @empid AND ep.IsDeleted = 0 and _cl.id = @listId

END


