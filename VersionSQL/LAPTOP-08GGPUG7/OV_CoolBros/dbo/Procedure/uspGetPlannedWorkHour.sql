/****** Object:  Procedure [dbo].[uspGetPlannedWorkHour]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPlannedWorkHour] 
	-- Add the parameters for the stored procedure here
	@startDate datetime, @toDate dateTime, @divisionFilter varchar(max), @departmentFilter varchar(max), @locationFilter varchar(max), @employeeStatusFilter varchar(max), @employeeTypeFilter varchar(max), @leaveTypeFilter varchar(max), @groupBy varchar(max), @sortBy varchar (max), @includeNotYetApprove int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @divisionTable table (idDivisionTable varchar(max));
	declare @departmentTable table (idDepartmentTable varchar(max));
	declare @locationTable table (idLocationTable varchar(max));
	declare @leaveTypeTable table (idLeaveType varchar(max));
	declare @employeeStatusTable table (idEmployeeStatusTable varchar(max));
	declare @employeeTypeTable table (idEmployeeTypeTable varchar(max));
	IF CHARINDEX(',', @divisionFilter, 0) > 0 BEGIN
		INSERT INTO @divisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionFilter, ',');	
    END
    ELSE IF LEN(@divisionFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @divisionTable(idDivisionTable) VALUES(@divisionFilter);	
    END

	IF CHARINDEX(',', @departmentFilter, 0) > 0 BEGIN
		INSERT INTO @departmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentFilter, ',');	
    END
    ELSE IF LEN(@departmentFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @departmentTable(idDepartmentTable) VALUES(@departmentFilter);	
    END

	IF CHARINDEX(';', @locationFilter, 0) > 0 BEGIN
		INSERT INTO @locationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationFilter, ';');	
    END
    ELSE IF LEN(@locationFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @locationTable(idLocationTable) VALUES(@locationFilter);	
    END

	IF CHARINDEX(';', @leaveTypeFilter, 0) > 0 BEGIN
		INSERT INTO @leaveTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@leaveTypeFilter, ';');	
    END
    ELSE IF LEN(@leaveTypeFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @leaveTypeTable(idLeaveType) VALUES(@leaveTypeFilter);	
    END	
	IF CHARINDEX(',', @employeeTypeFilter, 0) > 0 BEGIN
		INSERT INTO @employeeTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@employeeTypeFilter, ',');	
    END
    ELSE IF LEN(@employeeTypeFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeTypeTable(idEmployeeTypeTable) VALUES(@employeeTypeFilter);	
    END	

	IF CHARINDEX(',', @employeeStatusFilter, 0) > 0 BEGIN
		INSERT INTO @employeeStatusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@employeeStatusFilter, ',');	
    END
    ELSE IF LEN(@employeeStatusFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeStatusTable(idEmployeeStatusTable) VALUES(@employeeStatusFilter);	
    END		
select * 
from 
	(
	select
		e.id as EmpID,
		e.displayname as displayname,
		e.surname as surname,
		e.location as location,
		e.status as empstatus,
		e.type as emptype,
		p.title as title,
		isnull(p.orgunit2,'') as orgunit2,
		isnull(p.orgunit3,'') as orgunit3,
		ewh.ID as ID,
		--ewh.EmployeeID as test,
		ewh.DateFrom as StartDate,
		ewh.DateTo as EndDate,
		ew.DayCode as daycode,		
		ew.WorkHours as hours,
		ew.Week as _week,
		ewh.WeekMode as weekmode
	--	dbo.fnGetWeekByHeaderDate (ewh.id, @startDate) as actualWeek
	from 
		Employee e
		inner join EmployeePosition ep on e.id= ep.employeeid
		inner join Position p on ep.positionid=p.id
		inner join EmployeeWorkHoursHeader ewh on ewh.EmployeeID= e.id
		inner join EmployeeWorkHours ew on ew.EmployeeWorkHoursHeaderID=ewh.ID			
	where 
		ep.primaryposition='Y' and ep.IsDeleted=0
		and ((ewh.DateFrom<=@toDate and ewh.DateTo>=@startDate) or (ewh.DateFrom<=@toDate and ewh.DateTo is null))
		and dbo.fnHasWorkHeaderInPeriod(e.id, @startDate, @toDate)!=0
		and ep.vacant='N'
		and e.IsPlaceholder!=1		
		and ew.Enabled=1		
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR e.location IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))
UNION
	select
		e.id as EmpID,
		e.displayname as displayname,
		e.surname as surname,
		e.location as location,
		e.status as empstatus,
		e.type as emptype,
		p.title as title,
		isnull(p.orgunit2,'') as orgunit2,
		isnull(p.orgunit3,'') as orgunit3,
		lr.ID as ID,
		--'' as test,
		lrd.LeaveDateFrom as StartDate,
		lrd.LeaveDateTo as EndDate,
		lt.BackgroundColour as daycode,		
		lrd.Duration as hours,
		0 as _week,
		0 as weekmode
	--	dbo.fnGetWeekByHeaderDate(lr.EmployeeWorkHoursHeaderID, @startDate) as actualWeek
		--0 as ActualToWeek
	from  
		Employee e
		inner join EmployeePosition ep on e.id= ep.employeeid
		inner join Position p on ep.positionid=p.id
		inner join LeaveRequest lr on e.id= lr.EmployeeID
		inner join LeaveRequestDetail lrd on lr.ID= lrd.LeaveRequestID
		inner join LeaveType lt on lr.LeaveTypeID= lt.ID
		inner join LeaveStatus ls on lr.LeaveStatusID= ls.ID
	where 
		ep.primaryposition='Y' and ep.IsDeleted=0
		and ep.vacant='N'
		and e.IsPlaceholder!=1		
		and (lr.DateFrom <=@toDate and lr.DateTo>=@startDate)
		and ((ls.Code='A' and @includeNotYetApprove=0) or (@includeNotYetApprove=1))
		and ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR e.location IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR lt.ReportDescription IN (SELECT * FROM @leaveTypeTable))	
UNION
	select
		0 as EmpID,
		h.Description as displayname,
		t.BackgroundColour as surname,
		'' as location,
		'' as empstatus,
		'' as emptype,
		'' as title,
		'' as orgunit2,
		'' as orgunit3,
		0 as ID,
		--'' as test,
		h.Date as StartDate,
		h.Date as EndDate,
		'' as daycode,		
		0 as hours,
		-1 as _week,
		-1 as weekmode
	--	0 as actualWeek
	--	0 as ActualStartWeek,
	--	0 as ActualToWeek
	from
		holiday h, LeaveType t
	where
		t.Code='P' 
		and h.Date>=@startDate and h.Date<=@toDate
		AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR t.[ReportDescription] IN (SELECT * FROM @leaveTypeTable))
	) as Result		
	--where Result.weekmode=0
	ORDER BY		
		CASE WHEN @groupBy = 'orgunit2' THEN Result.orgunit2 END,		
		CASE WHEN @groupBy = 'orgunit3' THEN Result.orgunit3 END,
		CASE WHEN @groupBy = 'location' THEN Result.location END,			
		CASE WHEN @groupBy = 'leavestatus' THEN Result.title END,
		Result.id, _week	
									
END

