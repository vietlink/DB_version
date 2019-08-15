/****** Object:  Function [dbo].[fnGetHoursFromLeaveDate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[fnGetHoursFromLeaveDate](@empId int, @date int)
RETURNS decimal(18,2)
AS
BEGIN
	DECLARE @result decimal(18,2)
	SELECT 
		@result = CAST(lrd.Duration as decimal(18,2))
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
	WHERE lr.EmployeeID = @empID AND ewh.EmployeeWorkHoursHeaderID = lrd.EmployeeWorkHoursHeaderID AND [week] = dbo.fnGetWeekByHeaderDate(lrd.EmployeeWorkHoursHeaderID, @date)
	AND	lrd.LeaveDateFrom = @date;

	return ISNULL(@result, 0.0)
END

