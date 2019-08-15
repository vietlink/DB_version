/****** Object:  Procedure [dbo].[uspGetEmployeeWithEPByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeWithEPByID](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT e.id, p.id as positionid, ep.id as epId, e.displayname, p.title as position, epM.employeeid as ManagerID
	FROM Employee e
	INNER JOIN
	EmployeePosition ep
	ON
	ep.employeeid = e.id
	INNER JOIN
	Position p
	
	ON
	ep.positionid = p.id
	INNER JOIN EmployeePosition epM ON ep.ManagerID= epM.id	
	WHERE ep.primaryposition = 'Y' AND ep.IsDeleted = 0 AND e.id = @empId;
END
