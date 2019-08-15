/****** Object:  Procedure [dbo].[uspGetTimesheetHeaderIDByCycleAndEmp]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimesheetHeaderIDByCycleAndEmp](@payrollCycleId int, @empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @id int = 0;
	SELECT @id = id FROM TimesheetHeader WHERE PayrollCycleID = @payrollCycleId AND EmployeeID = @empId;

	RETURN @id;
END

