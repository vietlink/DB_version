/****** Object:  Procedure [dbo].[uspGetManagerSubmittedTimesheetCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetManagerSubmittedTimesheetCount](@managerEmpId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @submittedId int = 0;
	SELECT @submittedId = ID FROM TimesheetStatus WHERE Code = 'S'
	
    SELECT
		COUNT(*) as [count]
	FROM
		TimesheetHeader ts
	INNER JOIN
		PayrollCycle pc
	ON
		ts.PayrollCycleID = pc.id
	INNER JOIN
		PayrollCycleGroups pcg
	ON
		pc.PayrollCycleGroupID = pcg.ID
	INNER JOIN
		TimesheetStatus tss
	ON
		tss.ID = ts.TimesheetStatusID
	INNER JOIN
		Employee e
	ON
		e.ID = ts.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0 AND ep.primaryposition = 'Y'
	INNER JOIN
		Position p
	ON
		p.ID = ep.positionid
	INNER JOIN
		EmployeePosition epM
	ON
		epM.EmployeeID = @managerEmpId AND epM.id = ep.ManagerID

	WHERE
		ts.TimesheetStatusID = @submittedId

END

