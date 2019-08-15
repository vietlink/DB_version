/****** Object:  Procedure [dbo].[uspRegenAccrueData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRegenAccrueData](@StartDate DateTime, @EmpID int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @EndDate DateTime = Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()));
	DECLARE @CurrentDate DateTime = Convert(DateTime, DATEDIFF(DAY, 0, @StartDate));

	DECLARE @typeId int;
	SELECT @typeId = id FROM LeaveTransactionTypes WHERE Code = 'A';

	IF EXISTS(SELECT ID FROM EmployeeWorkHoursHeader WHERE [DateFrom] < @StartDate AND EmployeeID = @EmpID) BEGIN
		DELETE FROM LeaveAccrualTransactions WHERE [DateFrom] >= @StartDate AND EmployeeID = @EmpID AND TransactionTypeID = @typeId
	END ELSE BEGIN
		DELETE FROM LeaveAccrualTransactions WHERE EmployeeID = @EmpID AND TransactionTypeID = @typeId
	END

	WHILE (@CurrentDate <= @EndDate)
	BEGIN
		EXEC dbo.uspGenerateAccrueData @CurrentDate, @EmpID, 1;
		DECLARE @yesterday DateTime = dateadd(day, -1, @CurrentDate);
		EXEC dbo.uspGenerateAccrueData @yesterday, @EmpID, 0;
		SET @CurrentDate = convert(varchar(30), dateadd(day,1, @CurrentDate), 101); /*increment current date*/
	END
END
