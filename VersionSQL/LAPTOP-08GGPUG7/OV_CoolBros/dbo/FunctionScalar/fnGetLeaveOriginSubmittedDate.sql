/****** Object:  Function [dbo].[fnGetLeaveOriginSubmittedDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetLeaveOriginSubmittedDate] 
(
	-- Add the parameters for the function here
	@leaveID int
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime
	DECLARE @pendingStatus int = (SELECT lt.ID FROM LeaveStatus lt WHERE lt.Code='P')
	-- Add the T-SQL statements to compute the return value here
	SET @Result =(SELECT TOP 1 lsh.Date from LeaveStatusHistory lsh 
	where lsh.LeaveRequestID= @leaveID AND lsh.LeaveStatusID=@pendingStatus
	ORDER BY lsh.Date ASC)

	-- Return the result of the function
	RETURN @Result

END

