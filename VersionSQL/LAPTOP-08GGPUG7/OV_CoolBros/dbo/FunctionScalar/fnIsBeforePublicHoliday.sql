/****** Object:  Function [dbo].[fnIsBeforePublicHoliday]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Viet Linh
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnIsBeforePublicHoliday]
(
	-- Add the parameters for the function here
	@sickleaveDate datetime, @empID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int
	DECLARE @closestWDBefore DATETIME;
	SET @closestWDBefore = dbo.fnGetClosestWDBefore(@sickleaveDate, @empID);
	-- Add the T-SQL statements to compute the return value here
	SET @Result= dbo.fnIsPublicHolidayOnDay(@closestWDBefore, 0)

	-- Return the result of the function
	RETURN @Result

END

