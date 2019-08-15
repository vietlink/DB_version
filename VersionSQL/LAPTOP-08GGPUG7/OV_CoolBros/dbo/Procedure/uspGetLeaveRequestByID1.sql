/****** Object:  Procedure [dbo].[uspGetLeaveRequestByID1]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveRequestByID1](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT top 1
		r.ID,
		r.EmployeeID,
		e.displayname,
		t.reportdescription,
		p.title as Title,
		t.ReportDescription as LeaveType,
		t.Code as LeaveTypeCode,
		t.ID AS LeaveTypeID,
		t.BackgroundColour,
		t.FontColour,
		s.[Description] as LeaveStatus,
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
		dbo.fnGetLeaveOriginSubmittedDate(r.id) as submitted_date,
		dbo.fnGetLeaveOriginComment(r.id) as comment,
		dbo.fnGetLeaveLastComment(r.id, r.LeaveStatusID) as lastComment
	FROM
		LeaveRequest r
	INNER JOIN
		Employee e
	ON
		e.id = r.EmployeeID
	inner join EmployeePosition ep on e.id= ep.employeeid
	inner join Position p on ep.positionid= p.id
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
	INNER JOIN 
		LeaveStatusHistory lsh
	ON
		r.ID=lsh.LeaveRequestID
	WHERE r.id = @id
	and ep.primaryposition='Y' and ep.IsDeleted=0;
END
