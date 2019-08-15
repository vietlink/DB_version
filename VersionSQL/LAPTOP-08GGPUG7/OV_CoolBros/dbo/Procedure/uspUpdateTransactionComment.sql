/****** Object:  Procedure [dbo].[uspUpdateTransactionComment]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateTransactionComment] 
	-- Add the parameters for the stored procedure here
	@headerID int, 
	@reason varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update lat
	set lat.Comment= @reason
	from LeaveAccrualTransactions lat
	where lat.ID in (
	select lat.ID 
	from LeaveAccrualTransactions lat 
	inner join LeaveAdjustmentPeople lap on lat.EmployeeID= lap.EmployeeID
	inner join LeaveAdjustmentHeader la on lap.LeaveAdjustmentHeaderID= la.ID
	where la.ID=@headerID and la.Date= lat.DateFrom and la.LeaveTypeID=lat.LeaveTypeID and lat.TransactionTypeID=2)
END

