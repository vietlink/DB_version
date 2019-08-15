/****** Object:  Function [dbo].[fnGetLeaveStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetLeaveStatus] 
(
	-- Add the parameters for the function here
	@id int
)
RETURNS varchar(25)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(25)
	DECLARE @code varchar(2)
	-- Add the T-SQL statements to compute the return value here
	DECLARE @isAutoApprove bit = (SELECT lr.isAutoApproved FROM LeaveRequest lr WHERE lr.ID= @id)
	
	SELECT @Result = ls.Description, @code= ls.Code
	FROM LeaveStatus ls INNER JOIN LeaveRequest lr ON ls.ID= lr.LeaveStatusID
	WHERE lr.ID = @id
	-- Return the result of the function
	IF (@isAutoApprove = 1 and @code='A') BEGIN
		SET @Result = 'Approved (Auto)'
	END
	RETURN @Result

END

