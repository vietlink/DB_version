/****** Object:  Procedure [dbo].[uspRegenAccrueDataByType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRegenAccrueDataByType](@StartDate DateTime, @EmpID int, @leaveTypeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @EndDate DateTime = GETDATE();
	DECLARE @CurrentDate DateTime = @StartDate;

	DECLARE @typeId int;
	SELECT @typeId = id FROM LeaveTransactionTypes WHERE Code = 'A';

	IF EXISTS(SELECT ID FROM EmployeeWorkHoursHeader WHERE [DateFrom] < @StartDate AND EmployeeID = @EmpID) BEGIN
		DELETE FROM LeaveAccrualTransactions WHERE [DateFrom] >= @StartDate AND EmployeeID = @EmpID AND TransactionTypeID = @typeId AND LeaveTypeID = @leaveTypeId
	END ELSE BEGIN
		DELETE FROM LeaveAccrualTransactions WHERE EmployeeID = @EmpID AND TransactionTypeID = @typeId AND LeaveTypeID = @leaveTypeId
	END

	WHILE (@CurrentDate < @EndDate)
	BEGIN
		EXEC dbo.uspGenerateAccrueDataByType @CurrentDate, @EmpID, 1, @leaveTypeId;
		DECLARE @yesterday DateTime = dateadd(day, -1, @CurrentDate);
		EXEC dbo.uspGenerateAccrueDataByType @yesterday, @EmpID, 0, @leaveTypeId;
		SET @CurrentDate = convert(varchar(30), dateadd(day,1, @CurrentDate), 101); /*increment current date*/
	END
END

