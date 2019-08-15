/****** Object:  Function [dbo].[fnGetLeaveLastSubmitterID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetLeaveLastSubmitterID] 
(
	-- Add the parameters for the function here
	@headerID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SET @Result= (SELECT TOP 1 (lsh.SubmittedByID) 
	FROM LeaveStatusHistory lsh 	
	inner JOIN LeaveStatus ls ON lsh.LeaveStatusID= ls.ID AND ls.Code='P'
	WHERE 
	lsh.LeaveRequestID=@headerID
	ORDER BY lsh.date desc)


	-- Return the result of the function
	RETURN @Result

END

