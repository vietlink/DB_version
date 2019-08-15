/****** Object:  Function [dbo].[fnGetSumWorkHourByDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create FUNCTION [dbo].[fnGetSumWorkHourByDay] 
(
	-- Add the parameters for the function here
	@empID int, @date datetime
)
RETURNS decimal
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal

	-- Add the T-SQL statements to compute the return value here
	DECLARE @id int;

	SELECT @id = ISNULL(id, 0) FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND ((@date >= DateFrom AND @date <= cast(convert(char(8), DateTo, 112) + ' 23:59:59.99' as datetime))
	OR (@date >= DateFrom AND DateTo IS NULL))
	ORDER BY DateFrom DESC
	set @Result= (select sum(ew.WorkHours) from EmployeeWorkHours ew where ew.EmployeeWorkHoursHeaderID=@id and ew.Enabled=1)
	-- Return the result of the function
	RETURN @Result

END

