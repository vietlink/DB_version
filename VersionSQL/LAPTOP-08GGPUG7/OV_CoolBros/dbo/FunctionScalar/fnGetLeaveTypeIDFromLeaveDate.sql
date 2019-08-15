/****** Object:  Function [dbo].[fnGetLeaveTypeIDFromLeaveDate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[fnGetLeaveTypeIDFromLeaveDate](@empId int, @date int)
RETURNS int
AS
BEGIN
	DECLARE @result int
	SELECT 
		@result = lr.LeaveTypeID
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
	WHERE lr.EmployeeID = @empID AND ewh.EmployeeWorkHoursHeaderID = lrd.EmployeeWorkHoursHeaderID 
	AND	lrd.LeaveDateFrom = @date;

	return @result;
END

