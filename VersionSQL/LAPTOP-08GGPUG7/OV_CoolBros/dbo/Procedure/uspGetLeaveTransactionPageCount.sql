/****** Object:  Procedure [dbo].[uspGetLeaveTransactionPageCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveTransactionPageCount](@empId int, @leaveTypeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @classify int = 0;
	DECLARE @otherClassify int = 5;
	SELECT @classify = ISNULL(LeaveClassify, 0) FROM LeaveType WHERE id = @leaveTypeId

	SELECT
		ISNULL(COUNT(*),0) as ResultCount
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
		t.EmployeeID = @empId AND lt.LeaveClassify = @classify AND
		(lt.LeaveClassify <> @otherClassify OR lt.ID = @leaveTypeId)
END
