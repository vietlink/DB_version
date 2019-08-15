/****** Object:  Function [dbo].[fnGetBookedHoursInRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetBookedHoursInRange](@empId int, @from datetime, @to datetime, @leaveTypeId int, @excludeId int = 0)
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
		lr.ID <> @excludeId
		AND
		lrd.LeaveDateFrom >= @from AND lr.LeaveStatusID in (SELECT ID FROM LeaveStatus WHERE Code <> 'C' AND Code <> 'R')
		AND
		lr.LeaveTypeID = @leaveTypeId;

	RETURN @result;
END

