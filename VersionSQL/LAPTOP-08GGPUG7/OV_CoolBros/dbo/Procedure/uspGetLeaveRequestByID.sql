/****** Object:  Procedure [dbo].[uspGetLeaveRequestByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveRequestByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		r.EmployeeID,
		e.displayname,
		t.reportdescription,
		'' as Title,
		t.[Description] as LeaveType,
		t.Code as LeaveTypeCode,
		t.ID AS LeaveTypeID,
		t.BackgroundColour,
		t.FontColour,
		dbo.fnGetLeaveStatus (@id) as LeaveStatus,
		s.Code as LeaveStatusCode,
		r.ReasonForLeave,
		r.LeaveContactDetails,
		r.ApproverComments,
		r.TimePeriodRequested,
		r.DateFrom,
		r.DateTo,
		r.ExclWeekends,
		r.ExclPublicHolidays,
		r.ExclAlreadyRequested,
		ewh.WorkHours,
		dbo.fnGetHoursFromLeaveRequest(r.EmployeeID, r.id) as ActualHours,
		dbo.fnGetDaysFromLeaveHours(r.EmployeeID, r.id) as Days,
		r.Period,
		r.PeriodFrom,
		r.PeriodTo,
		Approved1,
		Approved2,
		ApprovedNegative,
		t.RequiresCancelApproval,
		Approver1EPID,
		Approver2EPID,
		Approver3EPID,
		app1.employeeid as Approver1EmpID,
		app2.employeeid as Approver2EmpID,
		app3.employeeid as Approver3EmpID,
		dbo.fnHasLeaveBeenApproved(r.id) as HasBeenApproved,
		r.ispaycyclelocked,
		ISNULL(r.documentid, 0) as documentid,
		r.isAutoApproved,
		isnull(dbo.fnGetLeaveLastSubmitterID(r.ID),0) as submitterID
	FROM
		LeaveRequest r
	INNER JOIN
		Employee e
	ON
		e.id = r.EmployeeID
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
		ewh.DayCode = DATENAME(dw, r.DateFrom) AND ewh.EmployeeWorkHoursHeaderID = r.EmployeeWorkHoursHeaderID AND
		ewh.[week] = dbo.fnGetWeekByHeaderDate(r.EmployeeWorkHoursHeaderID, r.DateFrom) AND ewh.[Enabled] = 1
	LEFT OUTER JOIN
		EmployeePosition app1
	ON
		app1.ID = r.Approver1EPID
	LEFT OUTER JOIN
		EmployeePosition app2
	ON
		app2.ID = r.Approver2EPID
	LEFT OUTER JOIN
		EmployeePosition app3
	ON
		app3.ID = r.Approver3EPID
	WHERE r.id = @id;
END
