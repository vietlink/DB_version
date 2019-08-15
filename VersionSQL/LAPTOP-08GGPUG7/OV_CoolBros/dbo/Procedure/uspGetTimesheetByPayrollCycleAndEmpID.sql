/****** Object:  Procedure [dbo].[uspGetTimesheetByPayrollCycleAndEmpID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimesheetByPayrollCycleAndEmpID](@empID int, @payrollCycleID int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @headerId int = 0;
	SELECT @headerId = ID FROM TimesheetHeader WHERE EmployeeID = @empID  AND PayrollCycleID = @payrollCycleID
	SELECT tsd.*, tsh.lastupdated, tss.Code as StatusCode, tsh.islocked, tsh.IsTimesheetApproved, tsh.IsAdditionalApproved FROM TimesheetDay tsd
	INNER JOIN
	TimesheetHeader tsh ON tsh.ID = tsd.TimesheetHeaderID
	INNER JOIN
	TimesheetStatus tss ON tss.ID = tsh.TimesheetStatusID
	WHERE TimesheetHeaderID = @headerId;
END

