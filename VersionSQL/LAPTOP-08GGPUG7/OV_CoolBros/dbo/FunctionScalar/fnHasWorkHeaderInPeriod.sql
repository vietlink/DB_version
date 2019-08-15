/****** Object:  Function [dbo].[fnHasWorkHeaderInPeriod]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnHasWorkHeaderInPeriod] 
(
	-- Add the parameters for the function here
	@empID int, @fromDate datetime, @toDate datetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = ISNULL(1,0) FROM EmployeeWorkHoursHeader ewh
	WHERE EmployeeID = @empId AND ((@toDate >= DateFrom AND @fromDate<= cast(convert(char(8), DateTo, 112) + ' 23:59:59.99' as datetime))
	OR (@toDate >= DateFrom AND DateTo IS NULL))
	ORDER BY DateFrom DESC

	-- Return the result of the function
	RETURN @Result

END

