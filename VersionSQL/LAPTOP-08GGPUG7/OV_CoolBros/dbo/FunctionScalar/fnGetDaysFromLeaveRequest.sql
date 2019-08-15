/****** Object:  Function [dbo].[fnGetDaysFromLeaveRequest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetDaysFromLeaveRequest] 
(
	-- Add the parameters for the function here
	@leaveID int
)
RETURNS decimal(5,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(5,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COUNT(*) FROM LeaveRequestDetail lrd WHERE lrd.LeaveRequestID= @leaveID

	-- Return the result of the function
	RETURN @Result

END

