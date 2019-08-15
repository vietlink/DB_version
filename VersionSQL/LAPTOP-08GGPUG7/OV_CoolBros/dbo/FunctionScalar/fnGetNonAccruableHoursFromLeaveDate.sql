/****** Object:  Function [dbo].[fnGetNonAccruableHoursFromLeaveDate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[fnGetNonAccruableHoursFromLeaveDate](@empId int, @date datetime, @leaveTypeId int)
RETURNS decimal(18,8)
AS
BEGIN
	DECLARE @result decimal(18,8)
	SELECT 
		@result = CAST(SUM(lrd.Duration) as decimal(18,8))
	FROM
		LeaveRequestDetail lrd
	INNER JOIN
		LeaveRequest lr
	ON
		lr.id = lrd.LeaveRequestID
	INNER JOIN
		EmployeeWorkHours ewh
	ON
		lr.EmployeeID = @empId AND ewh.DayCode = DATENAME(dw, lrd.LeaveDateFrom)
	WHERE lr.EmployeeID = @empID AND ewh.EmployeeWorkHoursHeaderID = lrd.EmployeeWorkHoursHeaderID AND ewh.[week] = dbo.fnGetWeekByHeaderDate(lrd.EmployeeWorkHoursHeaderID, lrd.LeaveDateFrom)
	AND	lrd.LeaveDateFrom = @date AND dbo.fnDoesLeaveTypeSupportLeaveTypeAccrual(@leaveTypeId, lr.LeaveTypeID) = 0

	return ISNULL(@result, 0.0)
END

