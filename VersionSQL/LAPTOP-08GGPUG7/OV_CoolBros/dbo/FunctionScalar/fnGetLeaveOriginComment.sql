/****** Object:  Function [dbo].[fnGetLeaveOriginComment]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetLeaveOriginComment]
(
	-- Add the parameters for the function here
	@leaveID int
)
RETURNS varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(max)
	DECLARE @pendingStatus int = (SELECT lt.ID FROM LeaveStatus lt WHERE lt.Code='P')
	-- Add the T-SQL statements to compute the return value here
	SET @Result =(SELECT TOP 1 lsh.Comment from LeaveStatusHistory lsh 
	where lsh.LeaveRequestID= @leaveID AND lsh.LeaveStatusID=@pendingStatus
	ORDER BY lsh.Date ASC)

	-- Return the result of the function
	RETURN @Result

END

