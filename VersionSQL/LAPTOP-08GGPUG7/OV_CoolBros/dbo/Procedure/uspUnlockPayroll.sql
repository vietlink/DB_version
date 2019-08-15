/****** Object:  Procedure [dbo].[uspUnlockPayroll]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUnlockPayroll] 
	-- Add the parameters for the stored procedure here	
	@payrollCycleID int
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update p
	set
	p.ClosedDate=NULL,
	p.PayrollStatusID=1,
	p.ClosedByEmpID=null
	from PayrollCycle p
	where p.ID=@payrollCycleID

	update lr
	set lr.IsPayCycleLocked=0
	from LeaveRequest lr
	inner join LeaveRequestDetail lrd on lr.ID= lrd.LeaveRequestID
	where lrd.PayrollCycleID=@payrollCycleID;

	update lat
	set lat.PayrollCycleID=0
	from LeaveAccrualTransactions lat
	where lat.PayrollCycleID=@payrollCycleID

	update lr
	set
	lr.PayrollCycleID=0
	from LeaveRequestDetail lr
	where lr.PayrollCycleID =@payrollCycleID	

	update ExpenseClaimDetail
	set PayCycleID=null
	where PayCycleID=@payrollCycleID

	update ExpenseClaimHeader
	set PayCycleID= null
	where PayCycleID= @payrollCycleID

	update TimesheetHeader
	set ProcessedPayCycleID=null
	where ProcessedPayCycleID= @payrollCycleID
END
