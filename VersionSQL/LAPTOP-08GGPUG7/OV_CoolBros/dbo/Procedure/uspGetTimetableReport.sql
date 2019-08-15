/****** Object:  Procedure [dbo].[uspGetTimetableReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimetableReport] 
	-- Add the parameters for the stored procedure here
	@empID int, @payrollCycleGroupID int, @fromDate datetime, @toDate datetime, @divisionList varchar(max), @departmentList varchar(max), @locationList varchar(max), @typeList varchar(max), @statusList varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @divisionTable TABLE(division varchar(max));
	DECLARE @statusTable TABLE(status varchar(max));	
	DECLARE @typeTable TABLE(type varchar(max));
	DECLARE @departmentTable TABLE(department varchar(max));	
	DECLARE @locationTable TABLE(location varchar(max));
	--DECLARE @employeeStatusTable TABLE(employeeStatus varchar(max));	
	DECLARE @headerTable TABLE (id int); 
	INSERT INTO @headerTable(id) SELECT p.ID FROM PayrollCycle p WHERE p.PayrollCycleGroupID=@payrollCycleGroupID AND p.ToDate<=@toDate AND p.FromDate>=@fromDate

	IF CHARINDEX(',', @divisionList, 0) > 0 BEGIN
		INSERT INTO @divisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionList, ',');	
    END
    ELSE IF LEN(@divisionList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @divisionTable(division) VALUES(@divisionList);	
    END
	
	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @statusTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusList, ',');	
    END
    ELSE IF LEN(@statusList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @statusTable(status) VALUES(@statusList);	
    END	

	IF CHARINDEX(',', @typeList, 0) > 0 BEGIN
		INSERT INTO @typeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@typeList, ',');	
    END
    ELSE IF LEN(@typeList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @typeTable(type) VALUES(@typeList);	
    END	

	IF CHARINDEX(',', @departmentList, 0) > 0 BEGIN
		INSERT INTO @departmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentList, ',');	
    END
    ELSE IF LEN(@departmentList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @departmentTable(department) VALUES(@departmentList);	
    END

	IF CHARINDEX(';', @locationList, 0) > 0 BEGIN
		INSERT INTO @locationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationList, ';');	
    END
    ELSE IF LEN(@locationList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @locationTable(location) VALUES(@locationList);	
    END
    -- Insert statements for procedure here
	SELECT e.id as empID, 
	e.displayname, 
	isnull(p.orgunit2,'(Blank)') as posorgunit2,
	isnull(p.orgunit3,'(Blank)') as posorgunit3,
	isnull(e.location, '(Blank)') as location,
	e.status as status, 
	isnull(e.type,'(Blank)') as emptype INTO #EmpList
	FROM Employee e 
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid= p.id
	WHERE ((SELECT COUNT(*) FROM @departmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @departmentTable))	
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR e.location IN (SELECT * FROM @locationTable))
	AND ((SELECT COUNT(*) FROM @statusTable) = 0 OR e.status IN (SELECT * FROM @statusTable)) 
	AND ((SELECT COUNT(*) FROM @typeTable) = 0 OR e.type IN (SELECT * FROM @typeTable))
	AND (e.id= @empID OR @empID=0)
SELECT * FROM(
	SELECT 
	0 as dayNo,
	e.empID as empID, 
	e.displayname, 
	e.posorgunit2,
	e.posorgunit3,
	e.location,
	e.status as status, 
	e.emptype,
	tsh.ID as timesheetheaderid,
	tsh.PayrollCycleID as PayrollCycleID, 
	'' as code,
	pc.Description, 
	pc.FromDate as fromDate,
	pc.ToDate as toDate,
	tsd.Date, 
	tsd.StartTime,
	tsd.FinishTime,
	tsd.Breaks,	
	tsd.Hours,
	'timesheet' as type,
	DATENAME(weekday, tsd.date) as daycode,
	isnull(tc.ID,0) as commentid,
	isnull(tc.Comment,'') as comment,
	isnull(tc.DateFor,'') as CommentDate,
	ewh.ApplyOvertimeOption  as overtimeoption,
	ewh.AllowOvertime as allowovertime,
	0 as leaveID,
	pp.Code as payCycleCode 
	
	FROM TimesheetDay tsd
	INNER JOIN TimesheetHeader tsh ON tsh.ID = tsd.TimesheetHeaderID
	left outer JOIN TimesheetComments tc ON tsd.date= tc.DateFor and tc.TimesheetHeaderID= tsh.ID
	INNER JOIN PayrollCycle pc ON tsh.PayrollCycleID= pc.ID
	INNER JOIN PayrollCyclePeriods pp ON pc.PayrollCyclePeriodID= pp.ID
	INNER JOIN #EmpList e ON tsh.EmployeeID= e.empID
	INNER JOIN EmployeeWorkHoursHeader ewh ON e.empID= ewh.EmployeeID 
	and dbo.fnGetWorkHourHeaderIDByDay(e.empID, tsd.Date)=ewh.ID
	
	
	WHERE tsh.PayrollCycleID in (SELECT * FROM @headerTable)
	
UNION
	SELECT 
	0 as dayNo,
	e.empID as empID, 
	e.displayname, 
	e.posorgunit2,
	e.posorgunit3,
	e.location,
	e.status as status, 
	e.emptype,
	tsh.ID as timesheetheaderid,
	tsh.PayrollCycleID as PayrollCycleID, 
	'' as code,
	pc.Description, 
	pc.FromDate as fromDate,
	pc.ToDate as toDate,
	tsd.Date, 
	tsd.StartTime,
	tsd.FinishTime,
	tsd.Breaks,	
	tsd.Hours,
	'timesheet' as type,
	DATENAME(weekday, tsd.date) as daycode,
	0 as commentid,
	'' as comment,
	'' as CommentDate,
	ewh.ApplyOvertimeOption  as overtimeoption,
	ewh.AllowOvertime as allowovertime,
	0 as leaveID, 
	pp.Code as payCycleCode
	FROM TimesheetDay tsd
	INNER JOIN TimesheetHeader tsh ON tsh.ID = tsd.TimesheetHeaderID
	--left outer JOIN TimesheetComments tc ON tsd.date= tc.DateFor and tc.TimesheetHeaderID= tsh.ID
	INNER JOIN PayrollCycle pc ON tsh.PayrollCycleID= pc.ID
	INNER JOIN PayrollCyclePeriods pp ON pc.PayrollCyclePeriodID = pp.ID
	INNER JOIN #EmpList e ON tsh.EmployeeID= e.empID
	INNER JOIN EmployeeWorkHoursHeader ewh ON e.empID= ewh.EmployeeID 
	and isnull(dbo.fnGetWorkHourHeaderIDByDay(e.empID, tsd.Date),0)!=ewh.ID and dbo.fnGetWorkHeaderInPeriod(e.empID, pc.FromDate, pc.ToDate)= ewh.id		
	WHERE tsh.PayrollCycleID in (SELECT * FROM @headerTable)	
	
UNION
	SELECT 
	-1 as dayNo,
	e.empID as empID, 
	e.displayname, 
	e.posorgunit2,
	e.posorgunit3,
	e.location,
	e.status as status, 
	e.emptype,
	tsh.ID as timesheetheaderid,
	tsh.PayrollCycleID, 
	
	lt.Code as code,
	lt.ReportDescription as description, 
	pc.FromDate as fromDate,
	pc.ToDate as toDate,
	lrd.LeaveDateFrom as Date, 
	lr.PeriodFrom as StartTime,
	lr.PeriodTo as FinishTime,
	0 as Breaks,	
	lrd.Duration as Hours,
	'leave' as type,
	DATENAME(weekday, lrd.LeaveDateFrom) as daycode,
	0 as commentid,
	'' as comment,
	'' as CommentDate,
	ewh.ApplyOvertimeOption as overtimeoption,
	ewh.AllowOvertime as allowovertime,
	lrd.ID as leaveID, 
	pp.Code as payCycleCode
	FROM TimesheetDay tsd
	INNER JOIN TimesheetHeader tsh ON tsh.ID = tsd.TimesheetHeaderID
	INNER JOIN PayrollCycle pc ON tsh.PayrollCycleID= pc.ID
	INNER JOIN PayrollCyclePeriods pp ON pc.PayrollCyclePeriodID = pp.ID
	INNER JOIN #EmpList e ON tsh.EmployeeID= e.empID
	INNER JOIN EmployeeWorkHoursHeader ewh ON e.empID= ewh.EmployeeID and dbo.fnGetWorkHourHeaderIDByDay(e.empID, tsd.Date)=ewh.ID	
	INNER JOIN LeaveRequest lr ON e.empID= lr.EmployeeID
	INNER JOIN LeaveRequestDetail lrd ON lr.ID= lrd.LeaveRequestID
	INNER JOIN LeaveType lt on lr.LeaveTypeID= lt.ID
	INNER JOIN  LeaveStatus ls on lr.LeaveStatusID= ls.ID
	WHERE tsh.PayrollCycleID in (SELECT * FROM @headerTable)
	and ls.Code='A'
	
	AND (lrd.LeaveDateFrom>=pc.FromDate AND lrd.LeaveDateFrom<=pc.ToDate)
UNION
	SELECT 
	-1 as dayNo,
	e.empID as empID, 
	e.displayname, 
	e.posorgunit2,
	e.posorgunit3,
	e.location,
	e.status as status, 
	e.emptype,
	tsh.ID as timesheetheaderid,
	tsh.PayrollCycleID, 
	
	lt.Code as code,
	lt.ReportDescription as description, 
	pc.FromDate as fromDate,
	pc.ToDate as toDate,
	h.Date as Date, 
	'' as StartTime,
	'' as FinishTime,
	0 as Breaks,	
	iif(dbo.fnGetHoursInDay(e.empID, h.Date)- tsd.Hours>0,dbo.fnGetHoursInDay(e.empID, h.Date)- tsd.Hours,0) as Hours,
	'leave' as type,
	DATENAME(weekday, h.Date) as daycode,
	0 as commentid,
	'' as comment,
	'' as CommentDate,
	ewh.ApplyOvertimeOption as overtimeoption,
	ewh.AllowOvertime as allowovertime,
	0 as leaveID, 
	pp.Code as payCycleCode
	FROM TimesheetDay tsd
	INNER JOIN TimesheetHeader tsh ON tsh.ID = tsd.TimesheetHeaderID
	INNER JOIN PayrollCycle pc ON tsh.PayrollCycleID= pc.ID
	INNER JOIN PayrollCyclePeriods pp ON pc.PayrollCyclePeriodID = pp.ID
	INNER JOIN #EmpList e ON tsh.EmployeeID= e.empID	
	INNER JOIN EmployeeWorkHoursHeader ewh ON e.empID= ewh.EmployeeID and dbo.fnGetWorkHourHeaderIDByDay(e.empID, tsd.Date)=ewh.ID
	LEFT OUTER JOIN HolidayRegion hr ON ewh.HolidayRegionID= hr.ID
	LEFT OUTER JOIN Holiday h ON hr.ID= h.HolidayRegionID, LeaveType lt
		
	WHERE 
	tsh.PayrollCycleID in (SELECT * FROM @headerTable)	
	and ewh.ModuleLeave=1
	and h.Date= tsd.Date
	
	and lt.Code='P'
	AND (h.Date>=pc.FromDate AND h.Date<=pc.ToDate)
	) as Result 
	
	order by Result.displayname, Result.PayrollCycleID, Result.Date, Result.type desc
	if (OBJECT_ID('tempdb..#EmpList') is not null)			
		drop table #EmpList
END

