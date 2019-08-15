/****** Object:  Procedure [dbo].[uspGetCurrentPayrollCycle]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCurrentPayrollCycle](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @date DateTime = GETDATE();

	DECLARE @currentHeaderID int = 0;
	EXEC @currentHeaderID = dbo.uspGetCurrentWorkHoursHeader @empId;

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

