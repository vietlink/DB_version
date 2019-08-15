/****** Object:  Function [dbo].[fnCheckAnnualLeaveOnDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnCheckAnnualLeaveOnDay] 
(
	-- Add the parameters for the function here
	@empID int, @date datetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	IF EXISTS (SELECT * 
	FROM LeaveRequest lr
	INNER JOIN LeaveRequestDetail lrd ON lr.id= lrd.LeaveRequestID 
	INNER JOIN LeaveType lt ON lr.LeaveTypeID = lt.ID
	WHERE (lt.SystemCode = 'A' OR lt.SystemCode='AL')
	AND lrd.leaveDatefrom = @date AND lr.EmployeeID= @empID
	and lr.IsCancelled=0)
	BEGIN 
		SET @Result= 1;
	END ELSE
	BEGIN
		SET @Result=0;
	END
	-- Return the result of the function
	RETURN @Result

END

