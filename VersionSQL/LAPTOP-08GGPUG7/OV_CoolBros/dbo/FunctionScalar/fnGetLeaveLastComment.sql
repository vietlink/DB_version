/****** Object:  Function [dbo].[fnGetLeaveLastComment]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetLeaveLastComment]
(
	-- Add the parameters for the function here
	@leaveID int, @leavestatusID int
)
RETURNS varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(max)	
	-- Add the T-SQL statements to compute the return value here
	SET @Result =(SELECT TOP 1 lsh.Comment from LeaveStatusHistory lsh 
	where lsh.LeaveRequestID= @leaveID
	and lsh.LeaveStatusID = @leavestatusID
	ORDER BY lsh.Date DESC)

	-- Return the result of the function
	RETURN @Result

END

