/****** Object:  Function [dbo].[fnGetDaysFromLeaveHours]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetDaysFromLeaveHours](@empId int, @leaveId int)
RETURNS decimal(18,2)
AS
BEGIN
	DECLARE @result decimal(18,2)
	SELECT 
		@result = CAST(SUM(case when ewh.workhours <= 0 then 0 else (lrd.Duration / dbo.fnGetAverageDayWorkHours(@empId, lrd.EmployeeWorkHoursHeaderID)) end) as decimal(18,2))
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
	WHERE lr.EmployeeID = @empId AND ewh.EmployeeWorkHoursHeaderID = lrd.EmployeeWorkHoursHeaderID AND ewh.[week] = dbo.fnGetWeekByHeaderDate(lrd.EmployeeWorkHoursHeaderID, lrd.LeaveDateFrom)
	return @result;
END

