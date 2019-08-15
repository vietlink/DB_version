/****** Object:  Function [dbo].[fnGetHoursFromLeaveRequest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetHoursFromLeaveRequest](@empId int, @leaveId int)
RETURNS decimal(18,2)
AS
BEGIN
	DECLARE @result decimal(18,2)
	SELECT 
		@result = CAST(SUM(lrd.Duration) as decimal(18,2))
	FROM
		LeaveRequestDetail lrd
	INNER JOIN
		LeaveRequest lr
	ON
		lr.id = lrd.LeaveRequestID
	INNER JOIN
		EmployeeWorkHours ewh
	ON
		lr.EmployeeID = @empId AND LeaveRequestID = @leaveId AND ewh.DayCode = DATENAME(dw, lrd.LeaveDateFrom)
	WHERE lr.EmployeeID = @empID AND ewh.EmployeeWorkHoursHeaderID = lrd.EmployeeWorkHoursHeaderID AND [week] = dbo.fnGetWeekByHeaderDate(lrd.EmployeeWorkHoursHeaderID, lrd.LeaveDateFrom)
	return @result;
END

