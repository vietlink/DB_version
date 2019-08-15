/****** Object:  Procedure [dbo].[uspCreateTOILFromTimesheet]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateTOILFromTimesheet](@headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @toilRate decimal(10, 5);
	SELECT @toilRate = ToilRate FROM TimesheetRateAdjustment WHERE TimesheetHeaderID = @headerId AND IsFinalisedHours  = 1

	IF ISNULL(@toilRate, 0) > 0 BEGIN
		DECLARE @payrollCycleId int = 0;
		DECLARE @empId int = 0;
		SELECT @payrollCycleId = PayrollCycleID, @empId = EmployeeID FROM TimesheetHeader WHERE ID = @headerId;
		
		DECLARE @date datetime;
		SELECT @date = ToDate FROM PayrollCycle WHERE ID = @payrollCycleId

		DECLARE @toilTypeId int = 0;
		SELECT @toilTypeId = ID FROM LeaveType WHERE Code = 'TOIL';

		DECLARE @adjustmentId int = 0;
		SELECT @adjustmentId = ID FROM LeaveTransactionTypes WHERE Code = 'CA';

		IF NOT EXISTS (SELECT ID FROM LeaveAccrualTransactions WHERE EmployeeID = @empId AND LeaveTypeID = @toilTypeId AND DateFrom = @date) BEGIN
			INSERT INTO LeaveAccrualTransactions(EmployeeID, LeaveTypeID, DateFrom, DateTo, TransactionTypeID, Balance, Taken, Adjustment, PayrollCycleID)
				VALUES(@empId, @toilTypeId, @date, @date, @adjustmentId, 0, NULL, @toilRate, @payrollCycleId)

			EXEC dbo.uspRegenAccrueDataByType @date, @empId, @toilTypeId
		END

	END
END

