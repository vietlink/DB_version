/****** Object:  Procedure [dbo].[uspDoesTimesheetExist]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDoesTimesheetExist](@empId int, @payrollId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM TimesheetHeader WHERE EmployeeID = @empID AND PayrollCycleID = @payrollId
END

