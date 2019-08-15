/****** Object:  Procedure [dbo].[uspGetWaitingRequestsByEscalationID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWaitingRequestsByEscalationID](@managerEmpId int, @managerPosId int, @header varchar(max), @sortOrder int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		r.EmployeeID,
		'' as Title,
		t.[Description] as LeaveType,
		t.Code as LeaveTypeCode,
		t.BackgroundColour,
		t.FontColour,
		s.[Description] as LeaveStatus,
		r.ReasonForLeave,
		r.LeaveContactDetails,
		r.ApproverComments,
		r.TimePeriodRequested,
		r.DateFrom as DateFrom,
		r.DateTo as DateTo,
		r.ExclWeekends,
		r.ExclPublicHolidays,
		ewh.WorkHours,
		dbo.fnGetHoursFromLeaveRequest(e.id, r.id) as ActualHours,
		dbo.fnGetDaysFromLeaveHours(e.id, r.id) as Days,
		r.ID as RequestID,
		e.displayname,
		s.shortdescription as leavestatusshortdescription,
		t.ReportDescription
	FROM
		LeaveRequest r
	INNER JOIN
		LeaveType t
	ON
		r.LeaveTypeID = t.ID
	INNER JOIN
		LeaveStatus s
	ON
		r.LeaveStatusID = s.ID
	INNER JOIN
		EmployeeWorkHours ewh
	ON
	 	ewh.EmployeeID = r.EmployeeID
	INNER JOIN
		Employee e
	ON
		e.ID = r.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0 AND primaryposition = 'Y'
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID
	LEFT OUTER JOIN
		EmployeePosition epM
	ON
		epM.id = ep.ManagerID
	INNER JOIN
		LeaveStatus ls
	ON
		ls.id = r.LeaveStatusID
	WHERE
		r.IsCancelled = 0 AND
		ewh.EmployeeWorkHoursHeaderID = r.EmployeeWorkHoursHeaderID AND ewh.DayCode = DATENAME(dw, r.DateFrom) AND ewh.[Enabled] = 1 AND ewh.[week] = dbo.fnGetWeekByHeaderDate(r.EmployeeWorkHoursHeaderID, r.DateFrom) AND (ls.Code = 'P' OR ls.code = 'PC')
		AND 
		(
			(t.ApprovalLevel < 3 AND
			(	
				(t.Escalate1ID = @managerPosId OR t.Escalate2ID = @managerPosId)
				OR
				(t.Approver2 = 1 AND epM.ID IN (SELECT * FROM dbo.fnGetChildrenIDsByManagerID(@managerEmpId)))
				OR
				(t.Approver2 = 2 AND epM.ID IN (SELECT * FROM dbo.fnGetChildrenIDsBySupervisorID(@managerPosId)))
			))
			OR
			(t.ApprovalLevel = 3 AND (p.ApprovalLevel = 2 OR t.overridepositionlevel = 1) AND
			(	
				(t.Escalate1ID = @managerPosId OR (R.Approver1EPID IS NOT NULL AND t.Escalate2ID = @managerPosId))
				OR
				(R.Approver1EPID IS NOT NULL AND t.Approver2 = 1 AND epM.ID IN (SELECT * FROM dbo.fnGetChildrenIDsByManagerID(@managerEmpId)))
				OR
				(R.Approver1EPID IS NOT NULL AND t.Approver2 = 2 AND epM.ID IN (SELECT * FROM dbo.fnGetChildrenIDsBySupervisorID(@managerPosId)))
			))
		)
		--AND (p.ApprovalLevel = 2 OR t.OverridePositionLevel = 1)
	--	AND
	--	(r.Approver2EPID IS NULL AND (t.ApprovalLevel = 2 OR (t.ApprovalLevel = 3 AND r.Approver1EPID IS NOT NULL)))
	ORDER BY 	
		CASE WHEN ((@sortOrder=1) AND (@header='thName')) THEN e.displayname END ASC,
		CASE WHEN ((@sortOrder=-1) AND (@header='thName')) THEN e.displayname END DESC,

		CASE WHEN ((@sortOrder=1) AND (@header='thType')) THEN t.Description END ASC,
		CASE WHEN ((@sortOrder=-1) AND (@header='thType')) THEN t.Description END DESC,

		CASE WHEN ((@sortOrder=1) AND (@header='thPeriod')) THEN r.DateFrom END ASC,
		CASE WHEN ((@sortOrder=-1) AND (@header='thPeriod')) THEN r.DateTo END DESC,
	r.datefrom, e.surname, e.firstname
END
