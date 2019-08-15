/****** Object:  Function [dbo].[fnGetLeaveSubmittedDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetLeaveSubmittedDate] 
(
	-- Add the parameters for the function here
	@headerID int
)
RETURNS varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(max)

	-- Add the T-SQL statements to compute the return value here
	SET @Result= (SELECT TOP 1 lsh.Date
	FROM LeaveStatusHistory lsh
	inner JOIN LeaveStatus ls ON lsh.LeaveStatusID= ls.ID AND ls.Code='P'
	WHERE 
	lsh.LeaveRequestID=@headerID
	ORDER BY lsh.Date desc)


	-- Return the result of the function
	RETURN @Result

END

