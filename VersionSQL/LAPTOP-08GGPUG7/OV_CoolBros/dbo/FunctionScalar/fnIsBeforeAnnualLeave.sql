/****** Object:  Function [dbo].[fnIsBeforeAnnualLeave]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Viet Linh
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnIsBeforeAnnualLeave] 
(
	-- Add the parameters for the function here
	@sickleaveDate datetime, @empID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int
	DECLARE @closestWDAfter DATETIME;
	SET @closestWDAfter = dbo.fnGetClosestWDAfter(@sickleaveDate, @empID);
	-- Add the T-SQL statements to compute the return value here
	SET @Result= dbo.fnCheckAnnualLeaveOnDay(@empID, @closestWDAfter)

	-- Return the result of the function
	RETURN @Result

END

