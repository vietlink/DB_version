/****** Object:  Function [dbo].[fnGetTotalAccrualCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetTotalAccrualCount](@date datetime, @empId int, @leaveTypeId int)
RETURNS decimal(18,8)
AS
BEGIN
	DECLARE @count decimal(18,8);
	DECLARE @takenCount decimal(18,8);

	DECLARE @leaveClassify int;
	DECLARE @otherClassify int = 5;

	SELECT @leaveClassify = ISNULL(LeaveClassify, 0) FROM LeaveType WHERE ID = @leaveTypeId;

	SELECT
		@count = SUM(Adjustment) 
	FROM
		LeaveAccrualTransactions act
	INNER JOIN 
		LeaveTransactionTypes ltt
	ON 
		ltt.ID = act.TransactionTypeID
	INNER JOIN
		LeaveType lt
	ON
		lt.ID = act.LeaveTypeID
	WHERE
		DateTo <= @date AND EmployeeID = @empId AND (ltt.Code = 'A' OR ltt.Code = 'CA') AND  lt.LeaveClassify = @leaveClassify AND
		(lt.LeaveClassify <> @otherClassify OR lt.ID = @leaveTypeId)

	SELECT
		@takenCount = SUM(Taken) 
	FROM
		LeaveAccrualTransactions act
	INNER JOIN 
		LeaveTransactionTypes ltt
	ON 
		ltt.ID = act.TransactionTypeID
	INNER JOIN
		LeaveType lt
	ON
		lt.ID = act.LeaveTypeID
	WHERE
		DateTo <= @date AND EmployeeID = @empId AND (ltt.Code = 'T' OR ltt.Code = 'CA') AND lt.LeaveClassify = @leaveClassify AND
		(lt.LeaveClassify <> @otherClassify OR lt.ID = @leaveTypeId)


	RETURN ISNULL(@count, 0.0) - ISNULL(@takenCount, 0.0);
END

