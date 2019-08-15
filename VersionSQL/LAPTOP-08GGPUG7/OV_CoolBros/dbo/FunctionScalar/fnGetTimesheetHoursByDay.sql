/****** Object:  Function [dbo].[fnGetTimesheetHoursByDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create FUNCTION [dbo].[fnGetTimesheetHoursByDay] 
(
	-- Add the parameters for the function here
	@date datetime, @empID int
)
RETURNS decimal(10,5)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(10,5)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = sum(td.Hours)
	from TimesheetDay td
	inner join TimesheetHeader th on th.ID= td.TimesheetHeaderID
	where td.Date= @date
	and th.EmployeeID=@empID
	-- Return the result of the function
	RETURN @Result

END

