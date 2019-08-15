/****** Object:  Procedure [dbo].[uspGetWaitingRequestsByManagerID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWaitingRequestsByManagerID](@managerEmpId int, @header varchar(max), @sortOrder int)
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
	 	ewh.EmployeeID = r.EmployeeID AND ewh.DayCode = DATENAME(dw, r.DateFrom)
	INNER JOIN
		Employee e
	ON
		e.ID = r.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0 AND ep.primaryposition = 'Y'
	INNER JOIN
		EmployeePosition epM
	ON
		epM.EmployeeID = @managerEmpId AND epM.id = ep.ManagerID
	INNER JOIN
		LeaveStatus ls
	ON
		ls.id = r.LeaveStatusID
	WHERE
		r.IsCancelled = 0 AND
		t.Approver1 = 1 AND
		ewh.EmployeeWorkHoursHeaderID = r.EmployeeWorkHoursHeaderID AND (ls.Code = 'P' OR ls.code = 'PC')
		AND ewh.[week] = dbo.fnGetWeekByHeaderDate(r.EmployeeWorkHoursHeaderID, r.DateFrom) AND ewh.[Enabled] = 1
		AND r.Approver1EPID IS NULL
		AND t.Escalate1ID <> epM.positionid
	ORDER BY
		CASE WHEN ((@sortOrder=1) AND (@header='thName')) THEN e.displayname END ASC,
		CASE WHEN ((@sortOrder=-1) AND (@header='thName')) THEN e.displayname END DESC,

		CASE WHEN ((@sortOrder=1) AND (@header='thType')) THEN t.Description END ASC,
		CASE WHEN ((@sortOrder=-1) AND (@header='thType')) THEN t.Description END DESC,

		CASE WHEN ((@sortOrder=1) AND (@header='thPeriod')) THEN r.DateFrom END ASC,
		CASE WHEN ((@sortOrder=-1) AND (@header='thPeriod')) THEN r.DateTo END DESC,
		r.datefrom, e.surname, e.firstname
END
