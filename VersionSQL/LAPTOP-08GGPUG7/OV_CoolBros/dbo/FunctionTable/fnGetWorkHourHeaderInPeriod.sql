/****** Object:  Function [dbo].[fnGetWorkHourHeaderInPeriod]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetWorkHourHeaderInPeriod] 
(	
	-- Add the parameters for the function here
	@empID int, 
	@start datetime,
	@to datetime
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT ewh.id
	from EmployeeWorkHoursHeader ewh
	where
	ewh.EmployeeID=@empID
	AND ((@to>= DateFrom AND @start<= cast(convert(char(8), DateTo, 112) + ' 23:59:59.99' as datetime))
	OR (@to >= DateFrom AND DateTo IS NULL))
)

