/****** Object:  Procedure [dbo].[uspGetFutureRequests]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFutureRequests](@dateFrom datetime, @empId int, @leaveTypeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @classify int = 0;
	DECLARE @otherClassify int = 5;
	SELECT @classify = ISNULL(LeaveClassify, 0) FROM LeaveType WHERE id = @leaveTypeId

    SELECT
		r.EmployeeID,
		'' as Title,
		t.[Description] as LeaveType,
		t.Code as LeaveTypeCode,
		t.BackgroundColour,
		t.FontColour,
		s.[Description] as LeaveStatus,
		s.Code as LeaveStatusCode,
		r.ReasonForLeave,
		r.LeaveContactDetails,
		isnull(r.ApproverComments, '') as ApproverComments,
		r.TimePeriodRequested,
		r.DateFrom as DateFrom,
		r.DateTo as DateTo,
		r.ExclWeekends,
		r.ExclPublicHolidays,
		ewh.WorkHours,
		CAST(r.TimePeriodRequested as decimal(18,5)) as ActualHours,
		dbo.fnGetDaysFromLeaveHours(r.EmployeeID, r.ID) as Days,
		r.ID as RequestID,
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
		EmployeeWorkHoursHeader ewhh
	ON
		r.EmployeeWorkHoursHeaderID = ewhh.ID
	INNER JOIN
		EmployeeWorkHours ewh
	ON
	 	ewhh.ID = ewh.EmployeeWorkHoursHeaderID AND ewh.DayCode = DATENAME(dw, r.DateFrom) AND ewh.[Enabled] = 1
	WHERE
		r.IsCancelled = 0 AND s.Code <> 'r' AND r.EmployeeID = @empId AND r.DateFrom > @dateFrom
		AND ewh.[week] = dbo.fnGetWeekByHeaderDate(r.EmployeeWorkHoursHeaderID, r.DateFrom) 
		AND t.LeaveClassify = @classify AND
		(t.LeaveClassify <> @otherClassify OR t.ID = @leaveTypeId)
	ORDER BY r.DateFrom ASC
END
