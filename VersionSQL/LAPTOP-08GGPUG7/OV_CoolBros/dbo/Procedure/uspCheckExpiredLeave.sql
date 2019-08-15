/****** Object:  Procedure [dbo].[uspCheckExpiredLeave]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckExpiredLeave]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	
	DECLARE leaveTypeCursor CURSOR  
		FOR SELECT ID, LeaveExpireDays, ZeroBalanceDay, ZeroBalanceMonth FROM LeaveType WHERE AccrueLeave = 1
	OPEN leaveTypeCursor  

	DECLARE @leaveTypeId int;
	DECLARE @leaveExpireDays int;
	DECLARE @zeroBalanceDay int;
	DECLARE @zeroBalanceMonth int;

	FETCH NEXT FROM leaveTypeCursor INTO @leaveTypeId, @leaveExpireDays, @zeroBalanceDay, @zeroBalanceMonth;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @leaveExpireDays IS NOT NULL AND @leaveExpireDays > 0 BEGIN
			DELETE FROM LeaveAccrualTransactions WHERE LeaveTypeID = @leaveTypeId
			AND DATEADD(day, @leaveExpireDays, DateFrom) < GETDATE()
		END

		IF @zeroBalanceDay IS NOT NULL AND @zeroBalanceMonth IS NOT NULL BEGIN
			IF @zeroBalanceDay = DATEPART(dd,GETDATE())  AND @zeroBalanceMonth = DATEPART(mm,GETDATE()) BEGIN
				DELETE FROM LeaveAccrualTransactions WHERE LeaveTypeID = @leaveTypeId
			END
		END

		FETCH NEXT FROM leaveTypeCursor INTO @leaveTypeId, @leaveExpireDays, @zeroBalanceDay, @zeroBalanceMonth;
	END;
	CLOSE leaveTypeCursor;
	DEALLOCATE leaveTypeCursor;
END

