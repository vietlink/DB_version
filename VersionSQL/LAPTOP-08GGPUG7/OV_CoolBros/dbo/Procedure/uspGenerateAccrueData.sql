/****** Object:  Procedure [dbo].[uspGenerateAccrueData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGenerateAccrueData](@currentDate datetime, @empId int, @accrueInAdvancedMode bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @headerId int = 0;
	SET @headerId = dbo.fnGetWorkHourHeaderIDByDay(@empId, @currentDate);

	DECLARE leaveTypeCursor CURSOR  
		FOR SELECT lt.ID, lt.AccrueAfterDays, lt.ZeroBalanceEnabled, lt.ZeroBalanceDay, lt.ZeroBalanceMonth, lt.AccrueInAdvanced, lt.MaxAccruedBalance FROM LeaveType lt
		INNER JOIN
		EmployeeLeaveTypes elt
		ON elt.LeaveTypeID = lt.ID
		WHERE lt.AccrueLeave = 1 AND elt.[Enabled] = 1 AND elt.EmployeeID  = @empId AND elt.EmployeeWorkHoursHeaderID = @headerId AND lt.AccrueInAdvanced = @accrueInAdvancedMode
	OPEN leaveTypeCursor  

	DECLARE @leaveTypeId int;
	DECLARE @accrueAfterDays int;
	DECLARE @zeroBalance bit;
	DECLARE @zeroBalanceDay int;
	DECLARE @zeroBalanceMonth int;
	DECLARE @accrueInAdvanced bit;
	DECLARE @maxAccruedBalance decimal(10,5);

	DECLARE @accruedTransactionId int;
	SELECT @accruedTransactionId = id FROM LeaveTransactionTypes WHERE code = 'A';

	DECLARE @adjustmentId int;
	SELECT @adjustmentId = id FROM LeaveTransactionTypes WHERE code = 'CA';

	DECLARE @commencement DateTime;
	SELECT @commencement = commencement FROM Employee WHERE id = @empId;

	DECLARE @currentDay int;
	DECLARE @currentMonth int;

	SELECT @currentDay = datepart(day,@currentDate), @currentMonth = datepart(month,@currentDate)

	FETCH NEXT FROM leaveTypeCursor INTO @leaveTypeId, @accrueAfterDays, @zeroBalance, @zeroBalanceDay, @zeroBalanceMonth, @accrueInAdvanced, @maxAccruedBalance
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @workedHours decimal(18,8) = 0;
		SELECT @workedHours = dbo.fnGetWorkedAccruableHours(@empId, @currentDate, @leaveTypeId);
		
		DECLARE @dailyAccrueRate decimal(25, 15);
		SELECT @dailyAccrueRate = dbo.fnGetAccrueHoursByLeaveType(@leaveTypeId);

		DECLARE @value decimal(25, 15) = @dailyAccrueRate * @workedHours;
		DECLARE @balance decimal(25, 15);-- = dbo.fnGetTotalAccrualCount(@currentDate, @empId, @leaveTypeId);

		DECLARE @currentBalance decimal(25,15) = dbo.fnGetTotalAccrualCount2(GETDATE(), @empId, @leaveTypeId, 0);

		IF ((@currentBalance + @value) < @maxAccruedBalance) OR ISNULL(@maxAccruedBalance, 0) = 0 
		BEGIN
			IF dbo.fnCheckNoAccruelLeaveBooked(@currentDate, @leaveTypeId, @empId) = 0 BEGIN
				IF ISNULL(@workedHours, 0) > 0 BEGIN

					UPDATE
						lat
					SET
						lat.Balance = dbo.fnGetTotalAccrualCount2(@currentDate, @empId, LeaveTypeID, TransactionTypeID)
					FROM
						LeaveAccrualTransactions lat
					INNER JOIN
						LeaveType lt
					ON
						lt.ID = lat.LeaveTypeID
					WHERE
						EmployeeID = @empId AND TransactionTypeID <> @accruedTransactionId AND DateFrom = @currentDate AND lt.AccrueInAdvanced = @accrueInAdvanced
							
					SET @balance = dbo.fnGetTotalAccrualCount2(@currentDate, @empId, @leaveTypeId, 0);
						
					IF @leaveTypeId = 20
						PRINT cast(@currentDate as varchar(20));	

					IF ISNULL(@dailyAccrueRate, 0) > 0 BEGIN
						IF @balance = 0 OR @balance IS NULL
							SET @balance = @value;
						ELSE
							SET @balance = @balance + @value;

						IF ((@accrueAfterDays IS NULL OR @accrueAfterDays = 0) OR GETDATE() >= DATEADD (day, @accrueAfterDays,@commencement))
						AND NOT EXISTS (SELECT ID FROM LeaveAccrualTransactions WHERE EmployeeID = @empId
							AND LeaveTypeID = @leaveTypeId AND DateFrom = @currentDate AND DateTo = @currentDate AND TransactionTypeID = @accruedTransactionId) BEGIN
							INSERT INTO LeaveAccrualTransactions(EmployeeID, LeaveTypeID, DateFrom, DateTo, TransactionTypeID,
								Balance, Taken, Adjustment, Mode)
							VALUES(@empId, @leaveTypeId, @currentDate, @currentDate, @accruedTransactionId, @balance, null, @value, 'Automatic')
						END
					END
				END
			END
		END
		ELSE IF (@currentBalance < @maxAccruedBalance) AND ISNULL(@dailyAccrueRate, 0) > 0 BEGIN
			DECLARE @fillValue decimal(25, 15);
			SET @fillValue = @maxAccruedBalance - @currentBalance;
			SET @balance = dbo.fnGetTotalAccrualCount2(@currentDate, @empId, @leaveTypeId, 0);

			IF @balance = 0 OR @balance IS NULL
				SET @balance = @fillValue;
			ELSE
				SET @balance = @balance + @fillValue;

			IF ((@accrueAfterDays IS NULL OR @accrueAfterDays = 0) OR GETDATE() >= DATEADD (day, @accrueAfterDays,@commencement))
			AND NOT EXISTS (SELECT ID FROM LeaveAccrualTransactions WHERE EmployeeID = @empId
				AND LeaveTypeID = @leaveTypeId AND DateFrom = @currentDate AND DateTo = @currentDate AND TransactionTypeID = @accruedTransactionId) BEGIN
				INSERT INTO LeaveAccrualTransactions(EmployeeID, LeaveTypeID, DateFrom, DateTo, TransactionTypeID,
					Balance, Taken, Adjustment, Mode)
				VALUES(@empId, @leaveTypeId, @currentDate, @currentDate, @accruedTransactionId, @balance, null, @fillValue, 'Automatic')
			END
		END
		IF @zeroBalance = 1 AND @zeroBalanceDay IS NOT NULL AND @zeroBalanceMonth IS NOT NULL BEGIN
			IF @zeroBalanceDay = @currentDay AND @zeroBalanceMonth = @currentMonth BEGIN
				IF NOT EXISTS (SELECT ID FROM LeaveAccrualTransactions WHERE EmployeeID = @empID AND LeaveTypeID = @leaveTypeId AND TransactionTypeID = @adjustmentId AND DateFrom = @currentDate) BEGIN
					DECLARE @newTaken decimal(10,5) = dbo.fnGetTotalAccrualCount2(@currentDate, @empId, @leaveTypeId, 0);
				
					INSERT INTO
						LeaveAccrualTransactions(EmployeeID, LeaveTypeID, DateFrom, DateTo, TransactionTypeID,
						Balance, Taken, Adjustment, Comment, Mode, LeaveRequestID)
					VALUES(
						@empId, @leaveTypeId, @currentDate, @currentDate, @adjustmentId, 0, @newTaken, 0, '', 'Expired', 0
					)
				END
			END
		END
		
		FETCH NEXT FROM leaveTypeCursor INTO @leaveTypeId, @accrueAfterDays, @zeroBalance, @zeroBalanceDay, @zeroBalanceMonth, @accrueInAdvanced, @maxAccruedBalance
	END
	CLOSE leaveTypeCursor;
	DEALLOCATE leaveTypeCursor;
END
