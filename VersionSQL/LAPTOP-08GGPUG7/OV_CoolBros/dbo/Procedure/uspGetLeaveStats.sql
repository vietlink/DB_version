/****** Object:  Procedure [dbo].[uspGetLeaveStats]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveStats](@empId int, @date datetime, @leaveTypeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @AnnualLeaveTypeId int = 0;
	DECLARE @SickLeaveTypeId int = 0;

	DECLARE @AnnualLeavePerYear decimal(10, 5)
	DECLARE @SickLeavePerYear decimal(10, 5)

	DECLARE @AnnualLeaveDays decimal(25, 15);
	DECLARE @AnnualLeaveHours decimal(25, 15);
	DECLARE @SickLeaveDays decimal(25, 15);
	DECLARE @SickLeaveHours decimal(25, 15);

	DECLARE @AnnualLeaveTaken decimal(25, 15);
	DECLARE @AnnualLeaveTakenHours decimal(25, 15);
	DECLARE @SickLeaveTaken decimal(25, 15);
	DECLARE @SickLeaveTakenHours decimal(25, 15);

	SELECT @AnnualLeaveTypeId = ID, @AnnualLeavePerYear = LeavePerYear FROM LeaveType WHERE Code = 'A';
	SELECT @SickLeaveTypeId = ID, @SickLeavePerYear = LeavePerYear FROM LeaveType WHERE Code = 'S';
	
	IF @leaveTypeID <> 0
		SET @AnnualLeaveTypeId = @leaveTypeId;
	
	SELECT
		@AnnualLeaveTaken = SUM(isnull(t.Taken, 0.0) / dbo.fnGetHoursInDay(@empId, t.datefrom)),
		@AnnualLeaveTakenHours = SUM(isnull(t.Taken, 0.0)),
		@AnnualLeaveDays = SUM(t.Adjustment / dbo.fnGetHoursInDay(@empId, t.datefrom)),
		@AnnualLeaveHours = SUM(t.Adjustment)
	FROM
		LeaveAccrualTransactions t
	INNER JOIN
		LeaveTransactionTypes ltt
	ON
		t.TransactionTypeID = ltt.id
	INNER JOIN
		LeaveType lt
	ON
		t.LeaveTypeID = lt.ID
	WHERE
		t.EmployeeID = @empId AND lt.ID = @AnnualLeaveTypeId AND t.DateFrom >= @date

	SELECT
		@SickLeaveTaken = SUM(isnull(t.Taken, 0.0) / dbo.fnGetHoursInDay(@empId, t.datefrom)),
		@SickLeaveTakenHours = SUM(isnull(t.Taken, 0.0)),
		@SickLeaveDays = SUM(t.Adjustment / dbo.fnGetHoursInDay(@empId, t.datefrom)),
		@SickLeaveHours = SUM(t.Adjustment)
	FROM
		LeaveAccrualTransactions t
	INNER JOIN
		LeaveTransactionTypes ltt
	ON
		t.TransactionTypeID = ltt.id
	INNER JOIN
		LeaveType lt
	ON
		t.LeaveTypeID = lt.ID
	WHERE
		t.EmployeeID = @empId AND lt.ID = @SickLeaveTypeId --AND t.DateFrom >= @date

	SELECT
		(@AnnualLeaveDays - @AnnualLeaveTaken) as annualLeaveAvailable,
		(@AnnualLeaveHours - @AnnualLeaveTakenHours) as annualLeaveAvailableHours,
		@AnnualLeaveTaken as annualLeaveTaken,
		@AnnualLeaveTakenHours as annualLeaveTakenHours,
		@AnnualLeavePerYear as annualLeavePerYear,
		(@SickLeaveDays - @SickLeaveTaken) as sickLeaveAvailable,
		(@SickLeaveHours - @SickLeaveTakenHours) as sickLeaveAvailableHours,
		@SickLeaveTaken as sickLeaveTaken,
		@SickLeaveTakenHours as sickLeaveTakenHours,
		@SickLeavePerYear as sickLeavePerYear

END

