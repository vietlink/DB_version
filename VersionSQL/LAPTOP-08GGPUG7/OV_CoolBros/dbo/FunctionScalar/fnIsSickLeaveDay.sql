/****** Object:  Function [dbo].[fnIsSickLeaveDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnIsSickLeaveDay] 
(
	-- Add the parameters for the function here
	@date datetime, @empID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SET @Result = (SELECT COUNT(*) FROM LeaveRequestDetail lrd 
	INNER JOIN LeaveRequest lr ON lrd.LeaveRequestID= lr.ID AND lr.EmployeeID= @empID
	INNER JOIN LeaveType lt ON lr.LeaveTypeID= lt.ID AND lt.Code='S'	
	WHERE lrd.LeaveDateFrom= @date)

	-- Return the result of the function
	RETURN @Result

END

