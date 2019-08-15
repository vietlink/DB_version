/****** Object:  Procedure [dbo].[uspRemoveTimesheetTOIL]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRemoveTimesheetTOIL](@headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @payrollCycleId int = 0;
	DECLARE @empId int = 0;
	SELECT @payrollCycleId = PayrollCycleID, @empId = EmployeeID FROM TimesheetHeader WHERE ID = @headerId;
		
	DECLARE @date datetime;
	SELECT @date = ToDate FROM PayrollCycle WHERE ID = @payrollCycleId

	DECLARE @toilTypeId int = 0;
	SELECT @toilTypeId = ID FROM LeaveType WHERE Code = 'TOIL';

	DECLARE @removeId int = 0;
	SELECT @removeId = ID FROM LeaveAccrualTransactions WHERE EmployeeID = @empId AND LeaveTypeID = @toilTypeId AND DateFrom = @date;
	IF @removeId > 0 BEGIN
		DELETE FROM LeaveAccrualTransactions WHERE ID = @removeId;
		EXEC dbo.uspRegenAccrueDataByType @date, @empId, @toilTypeId
	END
END

