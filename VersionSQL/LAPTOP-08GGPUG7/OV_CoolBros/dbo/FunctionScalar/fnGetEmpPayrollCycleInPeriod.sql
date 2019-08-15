/****** Object:  Function [dbo].[fnGetEmpPayrollCycleInPeriod]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetEmpPayrollCycleInPeriod] 
(
	-- Add the parameters for the function here
	@empID int, @from datetime, @to datetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @date DateTime = GETDATE();

	DECLARE @currentHeaderID int = 0;
	
	SELECT @currentHeaderID = ISNULL(id, 0) FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND ((DateFrom <= @to AND DateFrom>=@from) OR (DateFrom<=@to AND DateTo is null))
	ORDER BY DateFrom ASC
	

    DECLARE @payrollGroupID int = 0;
	SELECT @payrollGroupID = PayrollCycle FROM EmployeeWorkHoursHeader WHERE ID = @currentHeaderID

	DECLARE @currentId int = 0;
	SELECT
		TOP 1 @currentId = pc.ID
	FROM
		PayrollCycle pc
	INNER JOIN
		PayrollCycleGroups pg
	ON
		pc.PayrollCycleGroupID = pg.ID
	WHERE
		pg.ID = @payrollGroupID AND pc.FromDate = @from AND pc.ToDate = @to

	RETURN @currentId;

END

