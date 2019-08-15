/****** Object:  Procedure [dbo].[uspFinaliseDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspFinaliseDetail] 
	-- Add the parameters for the stored procedure here
	@leaveTransactionID varchar(max), @leaveRequestID varchar(max), @timesheetID varchar(max), @claimID varchar(max), @payrollID int, @empID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
	declare @leaveRequestTable Table (idLeaveRequest int);
	declare @leaveTransactionTable Table (idLeaveTransaction int);
	declare @timesheetTable Table (id int);
	declare @claimTable Table (id int);
	IF CHARINDEX(',', @leaveRequestID, 0) > 0 BEGIN
		INSERT INTO @leaveRequestTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@leaveRequestID, ',');	
		END
    ELSE IF LEN(@leaveRequestID) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @leaveRequestTable(idLeaveRequest) VALUES(CAST(@leaveRequestID as int));	
	end

	IF CHARINDEX(',', @leaveTransactionID, 0) > 0 BEGIN
		INSERT INTO @leaveTransactionTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@leaveTransactionID, ',');	
		END
    ELSE IF LEN(@leaveTransactionID) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @leaveTransactionTable(idLeaveTransaction) VALUES(CAST(@leaveTransactionID as int));	
		end   

	IF CHARINDEX(',', @timesheetID, 0) > 0 BEGIN
		INSERT INTO @timesheetTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@timesheetID, ',');	
		END
    ELSE IF LEN(@timesheetID) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @timesheetTable(id) VALUES(CAST(@timesheetID as int));	
	end

	IF CHARINDEX(',', @claimID, 0) > 0 BEGIN
		INSERT INTO @claimTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@claimID, ',');	
		END
    ELSE IF LEN(@claimID) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @claimTable(id) VALUES(CAST(@claimID as int));	
		end   
	Update p 
	set 
	p.PayrollStatusID=2,
	p.ClosedByEmpID=@empID,
	p.ClosedDate=CURRENT_TIMESTAMP	
	from dbo.PayrollCycle p
	where p.ID= @payrollID;

	--declare @from datetime;
	--declare @to datetime;
	--declare @type varchar(50);
	--declare @description varchar(max);
	--set @from=(select top 1 p.ToDate from PayrollCycle p order by p.ID desc);
	--set @from= dateadd(day, 1, @from)
	--set @type=(select p.PayrollCycleType from PayrollCycle p where p.ID= @payrollID);
	--if (@type='Fortnightly')
	--	set @to= dateadd(day, 14, @from)
	--else if (@type='Monthly')
	--	set @to= dateadd(month, 1, @from)
	--else if (@type= 'Weekly')
	--	set @to= dateadd(day, 7, @from)
	--set @description= concat(@type,': ', convert(varchar(11), @from, 106),'-', convert(varchar(11), @to, 106));
	--insert into PayrollCycle(Code, PayrollCycleType, Description, FromDate, ToDate, PayrollStatusID, ClosedByEmpID,ClosedDate )
	--values ('',@type, @description, @from, @to, 1, null, null)

	update lat
	set lat.payrollcycleID=@payrollID
	from LeaveAccrualTransactions lat
	where lat.ID in (select * from @leaveTransactionTable)
	update lr
	set
	lr.PayrollCycleID=@payrollID
	from LeaveRequestDetail lr
	where 
	lr.ID in (select * from @leaveRequestTable);

	update lr
	set lr.ispaycyclelocked=1
	from LeaveRequest lr
	inner join LeaveRequestDetail lrd on lr.ID=lrd.LeaveRequestID
	where lrd.PayrollCycleID=@payrollID

	update TimesheetHeader
	set ProcessedPayCycleID= @payrollID
	where id in (select * from @timesheetTable)

	update ExpenseClaimDetail 
	set PayCycleID= @payrollID
	where id in (select * from @claimTable)

	update ExpenseClaimHeader
	set PayCycleID= @payrollID
	where id in (select ecd.ExpenseClaimHeaderID from ExpenseClaimDetail ecd where ecd.ID in (select * from @claimTable))
END

