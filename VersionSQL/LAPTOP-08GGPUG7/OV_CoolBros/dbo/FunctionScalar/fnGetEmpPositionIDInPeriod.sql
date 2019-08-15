/****** Object:  Function [dbo].[fnGetEmpPositionIDInPeriod]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetEmpPositionIDInPeriod] 
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
	SELECT @Result = isnull((SELECT TOP 1 eph.id
						FROM EmployeePositionHistory eph
						WHERE eph.EmployeeID=@empID AND eph.primaryposition='Y'
						AND ((eph.startdate>=@from AND eph.startdate<=@to) OR (eph.startdate<=@to AND eph.enddate is null))
						ORDER BY eph.startdate desc),0)
	-- Return the result of the function
	RETURN @Result

END

