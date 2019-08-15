/****** Object:  Function [dbo].[fnGetEmpStatusIDInPeriod]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetEmpStatusIDInPeriod] 
(
	-- Add the parameters for the function here
	@from datetime, @to datetime, @empID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = isnull((SELECT TOP 1 (esh.id)
						FROM EmployeeStatusHistory esh
						WHERE esh.EmployeeID=@empID 
						AND ((esh.EndDate>@from AND esh.StartDate<=@to) OR (esh.startdate<=@to AND esh.enddate is null))
						ORDER BY esh.StartDate desc),0)

	-- Return the result of the function
	RETURN @Result

END

