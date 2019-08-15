/****** Object:  Procedure [dbo].[uspGetLeaveToPayroll]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Linh Ngo
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveToPayroll] 
	-- Add the parameters for the stored procedure here
	  (@fromDate DateTime, @toDate DateTime, @leaveTypeFilter varchar(max), @payrollCycleID int, @isFinalise int)	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @leaveTypeTable TABLE (leaveType varchar(max));
	IF CHARINDEX(';', @leaveTypeFilter, 0) > 0 BEGIN
		INSERT INTO @leaveTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@leaveTypeFilter, ';');	
    END
    ELSE IF LEN(@leaveTypeFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @leaveTypeTable(leaveType) VALUES(@leaveTypeFilter);	
    END	
    -- Insert statements for procedure here	
Select * from (
	SELECT 
		e.PayrollID as payrollID,
		e.id as EmployeeID,
		lr.ID as LeaveID,
		e.displayname as DisplayName,
		e.surname as Surname,
		lt.Code as Code,
		lt.ReportDescription as ReportDescription,
		lrd.LeaveDateFrom as DateFrom,	
		lrd.LeaveDateTo as DateTo,	
		lrd.Duration as Duration,
		lrd.payrollcycleid as paycycle,
		lrd.ID as LeaveDetailID,
		2 as isPayout
	FROM Employee e
		INNER JOIN EmployeePosition ep on e.id= ep.employeeid
		INNER JOIN LeaveRequest lr on e.id= lr.EmployeeID
		INNER JOIN LeaveRequestDetail lrd on lr.ID= lrd.LeaveRequestID
		INNER JOIN LeaveType lt on lr.LeaveTypeID= lt.ID
		INNER JOIN LeaveStatus ls on lr.LeaveStatusID=ls.ID
	WHERE 
		ls.Code='A'	
		and dbo.fnGetWorkHourHeaderIDByDay (e.id, lrd.LeaveDateFrom) !=0
		and 
		((((@isFinalise=1) and(@payrollCycleID !=0)) and (lrd.PayrollCycleID =@payrollCycleID))--get the finalised payroll and view leave request
		or 
		(((@isFinalise=1) and (@payrollCycleID =0)) and (lrd.LeaveDateFrom<=@toDate and lrd.PayrollCycleID =0)) --get the unfinalised payroll and leave requests
		or 
		(((@isFinalise=0) and (@payrollCycleID =0)) and (lrd.LeaveDateFrom<=@toDate and lrd.LeaveDateFrom>=@fromDate))) --only view the leave with in the period		
		and ep.primaryposition='Y' and ep.IsDeleted=0
		AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR lt.[ReportDescription] IN (SELECT * FROM @leaveTypeTable))		
UNION
	SELECT
		e.PayrollID as payrollID,
		e.id as EmployeeID,
		lat.ID as LeaveID,
		e.displayname as Displayname,
		e.surname as Surname,
		lt.Code as Code,
		lt.ReportDescription as ReportDescription,
		lat.DateFrom as DateFrom,
		lat.DateTo as DateTo,
		lat.Adjustment as Duration,
		lat.payrollcycleID as paycycle,
		0 as LeaveDetailID,
		lah.isPayout as isPayout
	FROM Employee e
	inner join EmployeePosition ep on e.id= ep.employeeid
	inner join LeaveAccrualTransactions lat on e.id= lat.EmployeeID
	inner join LeaveType lt on lat.LeaveTypeID= lt.ID
	inner join LeaveAdjustmentHeader lah on lat.LeaveAdjustmentHeaderID= lah.ID
	where ep.primaryposition='Y' and ep.IsDeleted=0
	AND lah.isPayout = 1
	AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR lt.[ReportDescription] IN (SELECT * FROM @leaveTypeTable))	
	and 
		((((@isFinalise=1) and(@payrollCycleID !=0)) and (lat.PayrollCycleID =@payrollCycleID))--get the finalised payroll and view leave request
		or 
		(((@isFinalise=1) and (@payrollCycleID =0)) and (lat.DateFrom<=@toDate and lat.PayrollCycleID =0)) --get the unfinalised payroll and leave requests
		or 
		(((@isFinalise=0) and (@payrollCycleID =0)) and (lat.DateFrom<=@toDate and lat.DateFrom>=@fromDate))) --only view the leave with in the period	
UNION
	select
		e.PayrollID as payrollID,
		e.id as EmployeeID,		
		0 as LeaveID,
		e.displayname as DisplayName,
		e.surname as Surname,
		lt.Code as Code,
		lt.ReportDescription as ReportDescription,
		h.Date as DateFrom,		
		h.Date as DateTo,
		8 as Duration,
		0 as paycycle,
		0 as LeaveDetailID,
		2 as isPayout		
	from Employee e
	INNER JOIN EmployeePosition ep on e.id= ep.employeeid
	inner join EmployeeWorkHoursHeader ewh on ewh.EmployeeID=e.id	
	inner join EmployeeWorkHours ew on ewh.ID= ew.EmployeeWorkHoursHeaderID 
	inner join HolidayRegion hr on ewh.HolidayRegionID=hr.ID
	inner join Holiday h on h.HolidayRegionID= hr.ID, LeaveType lt 
	where 		
		dbo.fnGetWorkHourHeaderIDByDay (e.id, h.Date)=ew.EmployeeWorkHoursHeaderID	
		and dbo.fnGetHoursInDay(e.id, h.Date) !=0	
		and lt.Code='P'
		and h.Date>=@fromDate and h.Date<=@toDate
		and ep.primaryposition='Y' and ep.IsDeleted=0
		AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR lt.[ReportDescription] IN (SELECT * FROM @leaveTypeTable))					
		) as ResultSet
	order by 
	ResultSet.surname,ResultSet.EmployeeID, ResultSet.ReportDescription, ResultSet.DateFrom

END
