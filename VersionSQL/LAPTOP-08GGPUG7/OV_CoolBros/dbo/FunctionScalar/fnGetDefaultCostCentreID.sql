/****** Object:  Function [dbo].[fnGetDefaultCostCentreID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create FUNCTION [dbo].[fnGetDefaultCostCentreID] 
(
	-- Add the parameters for the function here
	@empID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = (SELECT TOP 1 isnull(ewh.ExpenseCostCentreID,0) FROM EmployeeWorkHoursHeader ewh WHERE ewh.EmployeeID= @empID ORDER BY ewh.DateFrom DESC)

	-- Return the result of the function
	RETURN @Result

END

