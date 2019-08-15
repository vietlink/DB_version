/****** Object:  Procedure [dbo].[uspGetTimesheetsByEmployee]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimesheetsByEmployee](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @approvedId int = 0;
	SELECT @approvedId = ID FROM TimesheetStatus WHERE Code = 'A'
	DECLARE @rejectId int = 0;
	SELECT @rejectId = ID FROM TimesheetStatus WHERE Code = 'R'
	DECLARE @submittedId int = 0;
	SELECT @submittedId = ID FROM TimesheetStatus WHERE Code = 'S'

	DECLARE @approvedTimesheetId int = 0;
	SELECT @approvedTimesheetId = ID FROM TimesheetStatus WHERE Code = 'AT'

	DECLARE @approvedAdditionalId int = 0;
	SELECT @approvedAdditionalId = ID FROM TimesheetStatus WHERE Code = 'AA'

	SELECT 
		tsh.ID, tsh.PayrollCycleID, pcg.Description, pc.FromDate, pc.ToDate, 
		isnull(tsh.ContractedHours, 0) as ContractedHours,
		isnull(tsh.WorkedHours, 0) as WorkedHours, 
		isnull(tsh.LeaveHours, 0) as LeaveHours,
		isnull(tsh.TotalHours, 0) as TotalHours,
		isnull(tsh.OvertimeHours, 0) as OvertimeHours,
		isnull(tsh.ToilHours, 0) as ToilHours,
		tsh.CreatedBy, tsh.CreatedDate,
		tss.Description as [Status],
		pc.ClosedDate,
		approverE.displayname as ApproverName,
		tshApRj.[Date] as ApproverDate,
		submitE.displayname as SubmittedBy, 
		tshSub.[Date] AS SubmittedDate,
		tsh.islocked,
		tss.code as statuscode,
		tshApRj.HasBeenAdjusted as haschanged
	FROM 
		TimesheetHeader tsh
	INNER JOIN
		PayrollCycle pc
	ON
		pc.ID = tsh.PayrollCycleID
	INNER JOIN
		PayrollCycleGroups pcg
	ON
		pcg.ID = pc.PayrollCycleGroupID

	LEFT OUTER JOIN
		TimesheetStatusHistory tshApRj
	ON
		tshApRj.TimesheetHeaderID = tsh.ID AND (tshApRj.TimesheetStatusID = @approvedId OR tshApRj.TimesheetStatusID = @rejectId OR tshApRj.TimesheetStatusID = @approvedTimesheetId OR tshApRj.TimesheetStatusID = @approvedAdditionalId) AND tshApRj.[Date] = (SELECT MAX([Date]) FROM TimeSheetStatusHistory _tsh WHERE _tsh.TimesheetHeaderID = tsh.ID AND (_tsh.TimesheetStatusID = @approvedId OR _tsh.TimesheetStatusID = @rejectId OR tshApRj.TimesheetStatusID = @approvedTimesheetId OR tshApRj.TimesheetStatusID = @approvedAdditionalId) GROUP BY _tsh.TimesheetHeaderID)
	LEFT OUTER JOIN
		Employee approverE
	ON	
		approverE.ID = tshApRj.ApproverEmployeeID

	LEFT OUTER JOIN
		TimesheetStatusHistory tshSub
	ON
		tshSub.TimesheetHeaderID = tsh.ID AND (tshSub.TimesheetStatusID = @submittedId) AND tshSub.[Date] = (SELECT MAX([Date]) FROM TimeSheetStatusHistory _tsh WHERE _tsh.TimesheetHeaderID = tsh.ID AND _tsh.TimesheetStatusID = @submittedId GROUP BY _tsh.TimesheetHeaderID)
	LEFT OUTER JOIN
		Employee submitE
	ON	
		submitE.ID = tshSub.ApproverEmployeeID

	INNER JOIN
		TimesheetStatus tss
	ON
		tss.ID = tsh.TimesheetStatusID

	--LEFT OUTER JOIN
	--	TimesheetStatusHistory tshAT
	--ON
	--	tshAT.TimesheetHeaderID = tsh.ID AND (tshAT.TimesheetStatusID = @approvedTimesheetId) AND tshAT.[Date] = (SELECT MAX([Date]) FROM TimeSheetStatusHistory _tsh WHERE _tsh.TimesheetHeaderID = tsh.ID AND _tsh.TimesheetStatusID = @approvedTimesheetId GROUP BY _tsh.TimesheetHeaderID)
	--LEFT OUTER JOIN
	--	Employee empAT
	--ON	
	--	empAT.ID = tshAT.ApproverEmployeeID

	--LEFT OUTER JOIN
	--	TimesheetStatusHistory tshAA
	--ON
	--	tshAA.TimesheetHeaderID = tsh.ID AND (tshAA.TimesheetStatusID = @approvedAdditionalId) AND tshAA.[Date] = (SELECT MAX([Date]) FROM TimeSheetStatusHistory _tsh WHERE _tsh.TimesheetHeaderID = tsh.ID AND _tsh.TimesheetStatusID = @approvedAdditionalId GROUP BY _tsh.TimesheetHeaderID)
	--LEFT OUTER JOIN
	--	Employee empAA
	--ON	
	--	empAA.ID = tshAA.ApproverEmployeeID

	WHERE
		tsh.EmployeeID = @empId
	ORDER BY
		pc.FromDate DESC
	
END

