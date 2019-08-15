/****** Object:  Procedure [dbo].[uspGetRecentLeaveRequests]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRecentLeaveRequests](@empId int, @leaveTypeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 5
		r.EmployeeID,
		'' as Title,
		t.[ReportDescription] as LeaveType,
		t.Code as LeaveTypeCode,
		t.BackgroundColour,
		t.FontColour,
		dbo.fnGetLeaveStatus(r.id) as LeaveStatus,
		s.Code as LeaveStatusCode,
		r.ReasonForLeave,
		r.LeaveContactDetails,
		r.ApproverComments,
		r.TimePeriodRequested,
		r.DateFrom,
		r.DateTo,
		r.ExclWeekends,
		r.ExclPublicHolidays,
		ewh.WorkHours,
		dbo.fnGetHoursFromLeaveRequest(@empId, r.id) as ActualHours,
		dbo.fnGetDaysFromLeaveHours(@empId, r.id) as Days,
		r.ID as RequestID,
		s.ShortDescription as leavestatusshortdescription,
		history.LeaveStatus as ApproverLeaveStatus,
		history.displayname as ApproverName
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
	CROSS APPLY
		(SELECT TOP 1 h.LeaveRequestID, dbo.fnGetLeaveStatus(r.ID) as LeaveStatus, e.Displayname 
		FROM LeaveStatusHistory h 
		INNER JOIN Employee e ON e.ID = h.ApproverEmployeeID 
		INNER JOIN LeaveStatus s ON s.ID = h.LeaveStatusID 
		WHERE h.LeaveRequestID = r.ID ORDER BY h.[Date] DESC) history
	WHERE ewh.EmployeeID = @empId AND ewh.EmployeeWorkHoursHeaderID = r.EmployeeWorkHoursHeaderID AND
	ewh.[week] = dbo.fnGetWeekByHeaderDate(r.EmployeeWorkHoursHeaderID, r.DateFrom) AND ewh.[Enabled] = 1
	AND (@leaveTypeId = 0 OR @leaveTypeId = t.ID)
	ORDER BY r.DateFrom DESC
END
