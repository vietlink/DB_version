/****** Object:  Procedure [dbo].[uspGetManagerSubmittedAdditionalTimesheetCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetManagerSubmittedAdditionalTimesheetCount](@managerEmpId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @submittedId int = 0;
	SELECT @submittedId = ID FROM TimesheetStatus WHERE Code = 'S'
	
	DECLARE @approvedId int = 0;
	SELECT @approvedId = ID FROM TimesheetStatus WHERE Code = 'AT'

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
		(ts.TimesheetStatusID = @submittedId OR ts.TimesheetStatusID = @approvedId)
		AND
		dbo.fnGetTimesheetAdjustmentCount(ts.ID) > 0
END

