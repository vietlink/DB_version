/****** Object:  Function [dbo].[fnGetTotalAccrualCount2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetTotalAccrualCount2](@date datetime, @empId int, @leaveTypeId int, @lttId int = 0)
RETURNS decimal(18,8)
AS
BEGIN
	DECLARE @count decimal(18,8);
	DECLARE @takenCount decimal(18,8);

	DECLARE @leaveClassify int;
	DECLARE @otherClassify int = 5;

	DECLARE @typeCode varchar(5) = ''
	SELECT @typeCode = Code FROM LeaveTransactionTypes WHERE id = @lttId;

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
		DateFrom <= @date AND EmployeeID = @empId AND (ltt.Code = 'A' OR ltt.Code = 'CA') AND  lt.LeaveClassify = @leaveClassify AND
		(lt.LeaveClassify <> @otherClassify OR lt.ID = @leaveTypeId) AND NOT (@typeCode = 'T' AND ltt.Code = 'CA' AND DateFrom = @Date)
		AND NOT (@typeCode = 'T' AND ltt.Code = 'A' AND DateFrom = @Date) AND NOT (@typeCode = 'CA' AND ltt.Code = 'A' AND DateFrom = @Date)

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
		DateFrom <= @date AND EmployeeID = @empId AND (ltt.Code = 'T' OR ltt.Code = 'CA') AND lt.LeaveClassify = @leaveClassify AND
		(lt.LeaveClassify <> @otherClassify OR lt.ID = @leaveTypeId) AND NOT (@typeCode = 'T' AND ltt.Code = 'CA' AND DateFrom = @Date)
		AND NOT (@typeCode = 'T' AND ltt.Code = 'A' AND DateFrom = @Date) AND NOT (@typeCode = 'CA' AND ltt.Code = 'A' AND DateFrom = @Date)


	RETURN ISNULL(@count, 0.0) - ISNULL(@takenCount, 0.0);
END

