/****** Object:  Function [dbo].[fnGetCurrentPayrollCycle]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetCurrentPayrollCycle] 
(
	-- Add the parameters for the function here
	@empID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @date DateTime = GETDATE();

	DECLARE @currentHeaderID int = 0;
	
	SELECT @currentHeaderID = ISNULL(id, 0) FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND DateFrom <= GETDATE()
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
		pg.ID = @payrollGroupID AND pc.FromDate <= @date AND pc.ToDate >= @date

	RETURN @currentId;

END

