/****** Object:  Procedure [dbo].[uspGetLeaveTransactions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveTransactions](@empId int, @leaveTypeId int, @page int)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @classify int = 0;
	DECLARE @otherClassify int = 5;
	SELECT @classify = ISNULL(LeaveClassify, 0) FROM LeaveType WHERE id = @leaveTypeId

	SELECT
		t.*, lt.[Description] as LeaveType, ltt.[Description] as LeaveTransactionType,
		t.Taken  as LeaveDays, -- day logic was removed to show in hours on all 3
		t.Balance as BalanceDays,
		t.Adjustment as AdjustmentDays,
		lh.Reason as reason
	FROM
		LeaveAccrualTransactions t
	INNER JOIN
		LeaveTransactionTypes ltt
	ON
		t.TransactionTypeID = ltt.id
	INNER JOIN
		LeaveType lt
	ON
		lt.ID = t.LeaveTypeID
	left outer join LeaveAdjustmentHeader lh on t.LeaveAdjustmentHeaderID=lh.ID
	WHERE
		t.EmployeeID = @empId AND lt.LeaveClassify = @classify AND
		(lt.LeaveClassify <> @otherClassify OR lt.ID = @leaveTypeId)
	ORDER BY
		t.DateFrom DESC, ltt.SortOrder ASC
	OFFSET (@page * 100) ROWS
	FETCH NEXT 100 ROWS ONLY
    
END
