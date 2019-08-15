/****** Object:  Procedure [dbo].[uspGetDetailToPayroll]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDetailToPayroll] 
	-- Add the parameters for the stored procedure here
	@paycycleID int, @leaveTypeList varchar(max), @timesheetIncluded int, @leaveIncluded int, @claimIncluded int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @payGroupID int = (SELECT isnull(p.PayrollCycleGroupID,0) FROM PayrollCycle p WHERE p.id= @paycycleID)
	DECLARE @fromDate DATETIME = (SELECT p.FromDate FROM PayrollCycle p WHERE p.id= @paycycleID)
	DECLARE @toDate DATETIME = (SELECT p.ToDate FROM PayrollCycle p WHERE p.id= @paycycleID)
	DECLARE @status varchar(1)= (SELECT ps.Code FROM PayrollCycle p INNER JOIN PayrollStatus ps ON p.PayrollStatusID= ps.ID WHERE p.ID= @paycycleID)
	DECLARE @expenseCode varchar(max)= (SELECT ec.Code FROM ExpenseClaimSettings t INNER JOIN ExpenseCode ec ON t.DefaultExpenseCodeID= ec.ID)
	DECLARE @expenseCodeDesc varchar(max)= (SELECT ec.Description FROM ExpenseClaimSettings t INNER JOIN ExpenseCode ec ON t.DefaultExpenseCodeID= ec.ID)
	DECLARE @nontaxexpenseCode varchar(max)= (SELECT ec.Code FROM ExpenseClaimSettings t INNER JOIN ExpenseCode ec ON t.MileageNonTaxExpenseCodeID= ec.ID)
	DECLARE @nontaxexpenseCodeDesc varchar(max)= (SELECT ec.Description FROM ExpenseClaimSettings t INNER JOIN ExpenseCode ec ON t.MileageNonTaxExpenseCodeID= ec.ID)
	declare @leaveTable Table (leave varchar(max));
	IF CHARINDEX(',', @leaveTypeList, 0) > 0 BEGIN
		INSERT INTO @leaveTable -- split the text by , and store in temp table
		SELECT splitdata FROM fnSplitString(@leaveTypeList, ',');	
		END
    ELSE IF LEN(@leaveTypeList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @leaveTable(leave) VALUES(@leaveTypeList);	
	end
    -- Insert statements for procedure here
SELECT * FROM (
	SELECT e.PayrollID as payrollID,
		e.id as EmployeeID,
		lrd.ID as detailID,
		e.displayname as DisplayName,
		e.surname as Surname,
		lt.Code as PayCode,
		lt.ReportDescription as PayCodeDescription,
		--CONCAT(lr.DateFrom,' - ', lr.DateTo) as _date,	
		lrd.LeaveDateFrom as _date,
		lrd.LeaveDateFrom as _todate,
		@fromDate as FromDate,
		@toDate as ToDate,
		lrd.Duration as Amount,
		lrd.payrollcycleid as paycycle,
		--lrd.ID as LeaveDetailID,
		2 as isPayout,
		'leave' as type,
		0 as CompRate,
		0 as GovRate	
	FROM Employee e
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	INNER JOIN LeaveRequest lr on e.id= lr.EmployeeID
	INNER JOIN LeaveRequestDetail lrd on lr.ID= lrd.LeaveRequestID
	INNER JOIN LeaveType lt on lr.LeaveTypeID= lt.ID	
	INNER JOIN LeaveStatus ls on lr.LeaveStatusID=ls.ID
	LEFT OUTER JOIN TimesheetHeader th ON e.id= th.EmployeeID
	WHERE ls.Code='A'
	AND @leaveIncluded=1
	AND (@timesheetIncluded=1 AND (th.PayrollCycleID=@paycycleID) OR @timesheetIncluded=0)
	AND ((SELECT COUNT(*) FROM @leaveTable) = 0 OR lt.ReportDescription IN (SELECT * FROM @leaveTable))		
	AND (((@status='O') AND ((lrd.LeaveDateFrom<=@toDate) AND lrd.PayrollCycleID=0)) OR ((@status='C') AND lrd.PayrollCycleID= @paycycleID))
UNION
	SELECT
		e.PayrollID as payrollID,
		e.id as EmployeeID,
		lat.ID as detailID,
		e.displayname as Displayname,
		e.surname as Surname,
		lt.Code as PayCode,
		lt.ReportDescription as PayCodeDescription,
		--concat(lah.Date,' - ', lah.Date) as _date,
		lah.Date as _date,
		lah.Date as _todate,
		@fromDate as FromDate,
		@toDate as ToDate,
		lat.Adjustment as Amount,
		lat.payrollcycleID as paycycle,
		--0 as LeaveDetailID,
		lah.isPayout as isPayout,
		'leave' as type,
		0 as CompRate,
		0 as GovRate	
	FROM Employee e
	left outer join EmployeePosition ep on e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	left outer join LeaveAccrualTransactions lat on e.id= lat.EmployeeID
	inner join LeaveType lt on lat.LeaveTypeID= lt.ID
	left outer join LeaveAdjustmentHeader lah on lat.LeaveAdjustmentHeaderID= lah.ID
	LEFT OUTER JOIN TimesheetHeader th ON e.id= th.EmployeeID
	where lah.isPayout = 1 and @leaveIncluded=1
	AND ((SELECT COUNT(*) FROM @leaveTable) = 0 OR lt.ReportDescription IN (SELECT * FROM @leaveTable))		
	AND (@timesheetIncluded=1 AND (th.PayrollCycleID=@paycycleID) OR @timesheetIncluded=0)
	AND (((@status='O') AND ((lat.DateFrom<=@toDate) AND lat.PayrollCycleID =0)) OR ((@status='C') AND lat.PayrollCycleID= @paycycleID))	
UNION
	select
		e.PayrollID as payrollID,
		e.id as EmployeeID,		
		0 as detailID,
		e.displayname as DisplayName,
		e.surname as Surname,
		lt.Code as PayCode,
		lt.ReportDescription as PayCodeDescription,
		h.Date as _date,
		h.Date as _todate,
		@fromDate as FromDate,
		@toDate as ToDate,
		dbo.fnGetHoursInDay(e.id, h.Date)- td.Hours as Amount,
		0 as paycycle,
		--0 as LeaveDetailID,
		2 as isPayout,
		'leave' as type,
		0 as CompRate,
		0 as GovRate			
	from Employee e
	LEFT OUTER JOIN TimesheetHeader th ON e.id= th.EmployeeID
	LEFT OUTER JOIN TimesheetDay td ON td.TimesheetHeaderID= th.ID
	INNER JOIN EmployeePosition ep on e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	inner join EmployeeWorkHoursHeader ewh on ewh.EmployeeID=e.id	
	inner join EmployeeWorkHours ew on ewh.ID= ew.EmployeeWorkHoursHeaderID 
	inner join HolidayRegion hr on ewh.HolidayRegionID=hr.ID
	inner join Holiday h on h.HolidayRegionID= hr.ID, LeaveType lt 
	
	where 		
		--dbo.fnGetWorkHourHeaderIDByDay (e.id, h.Date)=ew.EmployeeWorkHoursHeaderID	
		dbo.fnGetHoursInDay(e.id, h.Date)- td.Hours >0	
		and ewh.ModuleLeave=1
		and h.Date= td.Date
		and @leaveIncluded =1
		AND ((@timesheetIncluded=1 AND th.PayrollCycleID=@paycycleID) OR @timesheetIncluded=0)
		and lt.Code='P'
		and h.Date>=@fromDate and h.Date<=@toDate		
		AND ((SELECT COUNT(*) FROM @leaveTable) = 0 OR lt.ReportDescription IN (SELECT * FROM @leaveTable))
UNION
	select
		e.PayrollID as payrollID,
		e.id as EmployeeID,		
		th.ID as detailID,
		e.displayname as DisplayName,
		e.surname as Surname,
		lr.Code as PayCode,
		lr.Description as PayCodeDescription,
		pc.FromDate as _date,
		pc.ToDate as _todate,
		@fromDate as FromDate,
		@toDate as ToDate,
		th.WorkedHours as Amount,
		0 as paycycle,
		--0 as LeaveDetailID,
		2 as isPayout,
		'timesheet' as type,
		0 as CompRate,
		0 as GovRate		
	from Employee e
	INNER JOIN EmployeePosition ep on e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	INNER JOIN TimesheetHeader th ON th.EmployeeID= e.id
	INNER JOIN PayrollCycle pc ON th.PayrollCycleID= pc.ID
	LEFT OUTER JOIN PayrollCycleGroups pg ON pc.PayrollCycleGroupID= pg.ID 
	INNER JOIN TimesheetStatus ts ON th.TimesheetStatusID= ts.ID, LoadingRate lr

	where 		
		@timesheetIncluded=1
		and lr.IsNormalRate=1
		--and tra.NormalRate is not null
		and ts.Code='A'					
		and isnull(pg.ID, 0)=@payGroupID
		AND (((@status='O') AND (th.ProcessedPayCycleID is null and pc.ToDate<=@toDate ))
		OR ((@status='C') AND th.ProcessedPayCycleID = @paycycleID))	
UNION
	select
		e.PayrollID as payrollID,
		e.id as EmployeeID,		
		tra.ID as detailID,
		e.displayname as DisplayName,
		e.surname as Surname,
		lr.Code as PayCode,
		lr.Description as PayCodeDescription,
		pc.FromDate as _date,
		pc.ToDate as _todate,
		@fromDate as FromDate,
		@toDate as ToDate,
		trai.Balance as Amount,
		0 as paycycle,
		--0 as LeaveDetailID,
		2 as isPayout,
		'timesheet' as type,
		0 as CompRate,
		0 as GovRate		
	from Employee e
	INNER JOIN EmployeePosition ep on e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	INNER JOIN TimesheetHeader th ON th.EmployeeID= e.id
	INNER JOIN PayrollCycle pc ON th.PayrollCycleID= pc.ID
	LEFT OUTER JOIN PayrollCycleGroups pg ON pc.PayrollCycleGroupID= pg.ID
	INNER JOIN TimesheetStatus ts ON th.TimesheetStatusID= ts.ID
	INNER JOIN TimesheetRateAdjustment tra ON th.ID= tra.TimesheetHeaderID and tra.IsFinalisedHours = 1
	INNER JOIN TimesheetRateAdjustmentItem trai ON tra.ID= trai.TimesheetRateAdjustmentID
	INNER JOIN LoadingRate lr ON trai.RateID= lr.ID
	where 		
		@timesheetIncluded=1
		and lr.IsNormalRate!=1
		and tra.NormalRate is not null
		and ts.Code='A'
		--and th.PayrollCycleID= @paycycleID
		and ep.primaryposition='Y' and ep.IsDeleted=0	
		and isnull(pg.ID, 0)=@payGroupID
		AND (((@status='O') AND (th.ProcessedPayCycleID is null and pc.ToDate<=@toDate ))
		OR ((@status='C') AND th.ProcessedPayCycleID = @paycycleID))	
UNION
	select
		e.PayrollID as payrollID,
		e.id as EmployeeID,		
		ecd.ID as detailID,
		e.displayname as DisplayName,
		e.surname as Surname,
		@expenseCode as PayCode,
		@expenseCodeDesc as PayCodeDescription,
		ecd.ExpenseDate as _date,
		ecd.ExpenseDate as _todate,
		@fromDate as FromDate,
		@toDate as ToDate,
		ecd.TotalMileage* ecd.GovernmentTravelRate as Amount,
		isnull(ecd.PayCycleID,0) as paycycle,
		--0 as LeaveDetailID,
		2 as isPayout,
		'claim' as type,
		ecd.CompanyTravelRate as CompRate,
		ecd.GovernmentTravelRate as GovRate
	from Employee e
	INNER JOIN EmployeePosition ep on e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	INNER JOIN ExpenseClaimHeader ech ON e.id= ech.CreatedForUserID
	INNER JOIN ExpenseClaimDetail ecd ON ech.id= ecd.ExpenseClaimHeaderID
	INNER JOIN ExpenseStatus es ON ecd.ExpenseStatusID= es.ID
	where 		
		@claimIncluded=1
		and ech.ClaimType=2
		and es.Code='A'
		AND (((@status='O') AND (ecd.ExpenseDate<=@toDate AND ecd.PayCycleID is null)) OR ((@status='C') AND ecd.PayCycleID= @paycycleID))	
		and ep.primaryposition='Y' and ep.IsDeleted=0	
UNION
	select
		e.PayrollID as payrollID,
		e.id as EmployeeID,		
		ecd.ID as detailID,
		e.displayname as DisplayName,
		e.surname as Surname,
		@nontaxexpenseCode as PayCode,
		@nontaxexpenseCodeDesc as PayCodeDescription,
		ecd.ExpenseDate as _date,
		ecd.ExpenseDate as _todate,
		@fromDate as FromDate,
		@toDate as ToDate,
		ecd.ExpenseAmount -ecd.TotalMileage* ecd.GovernmentTravelRate as Amount,
		isnull(ecd.PayCycleID,0) as paycycle,
		--0 as LeaveDetailID,
		2 as isPayout,
		'claim' as type,
		ecd.CompanyTravelRate as CompRate,
		ecd.GovernmentTravelRate as GovRate
	from Employee e
	INNER JOIN EmployeePosition ep on e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	INNER JOIN ExpenseClaimHeader ech ON e.id= ech.CreatedForUserID
	INNER JOIN ExpenseClaimDetail ecd ON ech.id= ecd.ExpenseClaimHeaderID
	INNER JOIN ExpenseStatus es ON ecd.ExpenseStatusID= es.ID
	where 		
		@claimIncluded=1
		and ecd.GovernmentTravelRate<ecd.CompanyTravelRate
		and ech.ClaimType=2
		and es.Code='A'
		AND (((@status='O') AND (ecd.ExpenseDate<=@toDate AND ecd.PayCycleID is null)) OR ((@status='C') AND ecd.PayCycleID= @paycycleID))	
		and ep.primaryposition='Y' and ep.IsDeleted=0
	) as Result ORDER  BY Result.EmployeeID, Result.PayCode	
END

