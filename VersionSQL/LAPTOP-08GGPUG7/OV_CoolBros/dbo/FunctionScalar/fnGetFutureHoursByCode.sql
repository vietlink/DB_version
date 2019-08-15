/****** Object:  Function [dbo].[fnGetFutureHoursByCode]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[fnGetFutureHoursByCode](@empId int, @from datetime, @leaveTypeId int, @code varchar(5))
RETURNS decimal(10,5)
AS
BEGIN
	DECLARE @result decimal(10, 5)

	SELECT
		@result = SUM(Duration)
	FROM
		LeaveRequestDetail lrd
	INNER JOIN
		LeaveRequest lr
	ON
		lrd.LeaveRequestID = lr.ID
	WHERE
		lr.EmployeeID = @empId 
		AND
		lr.LEaveTypeID = @leaveTypeID
		AND
		lrd.LeaveDateFrom > @from AND lr.LeaveStatusID in (SELECT ID FROM LeaveStatus WHERE Code = @code)
	
	RETURN @result;
END

