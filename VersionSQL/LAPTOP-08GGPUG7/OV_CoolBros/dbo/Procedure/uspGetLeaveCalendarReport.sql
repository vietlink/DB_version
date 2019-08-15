/****** Object:  Procedure [dbo].[uspGetLeaveCalendarReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Linh Ngo
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveCalendarReport] 
	(@managerEmpId int, @dateFrom datetime, @dateTo datetime, @divisionFilterList varchar(max), @departmentFilterList varchar(max), @locationFilterList varchar(max), @leaveTypeFilter varchar(max), @sortBy varchar(max), @groupBy varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idDepartmentTable TABLE(idDepartment varchar(max));
	DECLARE @idDivisionTable TABLE(idDivision varchar(max));
	DECLARE @idLocationTable TABLE(idLocation varchar(max));
	DECLARE @leaveTypeTable TABLE(leaveType varchar(max));
	IF CHARINDEX(',', @divisionFilterList, 0) > 0 BEGIN
		INSERT INTO @idDivisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionFilterList, ',');	
    END
    ELSE IF LEN(@divisionFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDivisionTable(idDivision) VALUES(@divisionFilterList);	
    END

	IF CHARINDEX(',', @departmentFilterList, 0) > 0 BEGIN
		INSERT INTO @idDepartmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentFilterList, ',');	
    END
    ELSE IF LEN(@departmentFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDepartmentTable(idDepartment) VALUES(@departmentFilterList);	
    END

	IF CHARINDEX(';', @locationFilterList, 0) > 0 BEGIN
		INSERT INTO @idLocationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationFilterList, ';');	
    END
    ELSE IF LEN(@locationFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idLocationTable(idLocation) VALUES(@locationFilterList);	
    END

	IF CHARINDEX(';', @leaveTypeFilter, 0) > 0 BEGIN
		INSERT INTO @leaveTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@leaveTypeFilter, ';');	
    END
    ELSE IF LEN(@leaveTypeFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @leaveTypeTable(leaveType) VALUES(@leaveTypeFilter);	
    END
    Select * FROM 
	(SELECT
		r.EmployeeID as EmployeeID,
		p.ID as PositionID,
		ep.ID as EpID,		
		t.[ReportDescription] as LeaveType,
		t.Code as LeaveTypeCode,
		t.BackgroundColour as BackgroundColour,
		t.FontColour as FontColour,
		t.ID as LeaveID,
		s.[Description] as LeaveStatus,
		s.ShortDescription as LeaveDescription,		
		lrd.LeaveDateFrom as DateFrom,
		lrd.LeaveDateTo as DateTo,
		r.ExclWeekends as ExclWeekends,
		r.ExclPublicHolidays as ExclPublicHolidays,
		0 as WorkHours,
		sum(lrd.Duration) over (partition by e.id) as total_hour,
		lrd.duration as ActualHours,
		dbo.fnGetDaysFromLeaveHours(e.id, r.id) as Days,
		r.ID as RequestID,
		e.displayname as DisplayName,
		p.title as title,		
		s.Code as leavestatusshortdescription,
		r.PeriodFrom as PeriodFrom,
		r.PeriodTo as PeriodTo,
		p.orgunit3 as orgunit3,
		p.orgunit2 as orgunit2,
		e.location as location,
		e.surname as surname,
		1 as BookedLeave
	FROM
		LeaveRequest r
	INNER JOIN
		LeaveRequestDetail lrd
	ON
		lrd.LeaveRequestID = r.ID
	INNER JOIN
		LeaveType t
	ON
		r.LeaveTypeID = t.ID
	INNER JOIN
		LeaveStatus s
	ON
		r.LeaveStatusID = s.ID	
	INNER JOIN	
		Employee e
	ON
		e.ID = r.EmployeeID
		INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0 and ep.primaryposition='Y'	
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID
	INNER JOIN
		LeaveStatus ls
	ON
		ls.id = r.LeaveStatusID
	WHERE
		e.status<>'Deleted' and
		r.IsCancelled = 0 

		and s.Code!='R' and s.Code !='C'
		--and ewh.EmployeeWorkHoursHeaderID = r.EmployeeWorkHoursHeaderID 
		----and dbo.fnGetWorkHourHeaderIDByDay(e.id, lrd.LeaveDateFrom) is not null
		--and ((ew.DateFrom<=@dateTo  and ew.DateTo>=@dateFrom) or (ew.DateFrom<=@dateTo and ew.DateTo is null))
		--AND ewh.[week] = dbo.fnGetWeekByHeaderDate(lrd.EmployeeWorkHoursHeaderID, lrd.LeaveDateFrom) 
		AND	lrd.LeaveDateFrom >= @dateFrom AND lrd.LeaveDateFrom <= @dateTo
		and dbo.fnGetHoursInDay(e.id, lrd.LeaveDateFrom) is not null
		AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable))
		AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @idLocationTable))
		AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR t.[ReportDescription] IN (SELECT * FROM @leaveTypeTable))					
UNION
	SELECT
		ewh.EmployeeID as EmployeeID,
		p.id as PositionID,
		ep.id as EpID,		
		h.Description as LeaveType,
		t.SystemCode as LeaveTypeCode,
		t.BackgroundColour as BackgroundColour,
		t.FontColour as FontColour,
		t.ID as LeaveID,
		null as LeaveStatus,
		null as LeaveDescription,		
		h.Date as DateFrom,
		null as DateTo,
		null as ExclWeekends,
		null as ExclPublicHolidays,
		0 as WorkHours,
		0 as total_hour,
		0 as ActualHours,
		0  as Days,
		0  as RequestID,
		e.displayname  as DisplayName,
		p.title  as title,		
		null  as PeriodFrom,
		null  as PeriodTo,
		null  as leavestatusshortdescription,
		p.orgunit3  as orgunit3,
		p.orgunit2  as orgunit2,
		e.location  as location,
		e.surname  as surname,
		1 as BookedLeave	
	FROM LeaveType t, 
		
	Holiday h 
	INNER JOIN HolidayRegion hr ON h.HolidayRegionID= hr.ID
	INNER JOIN EmployeeWorkHoursHeader ewh ON ewh.HolidayRegionID= hr.ID and dbo.fnGetWorkHourHeaderIDByDay(ewh.EmployeeID, h.Date)=ewh.ID
	INNER JOIN Employee e ON ewh.EmployeeID= e.id
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0 and ep.primaryposition='Y'	
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID
	INNER JOIN LeaveRequest lr ON ewh.EmployeeID= lr.EmployeeID
	INNER JOIN LeaveRequestDetail lrd ON lrd.LeaveRequestID= lr.ID
	INNER JOIN LeaveStatus ls ON lr.LeaveStatusID= ls.ID


	WHERE t.SystemCode='P' 
	and h.Date>=@dateFrom and h.Date<=@dateTo
	AND e.status<>'Deleted' 
	AND lr.IsCancelled = 0 
	AND ls.Code!='R' and ls.Code !='C'
	AND	lrd.LeaveDateFrom >= @dateFrom AND lrd.LeaveDateFrom <= @dateTo
	AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable))
		AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @idLocationTable))
	AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR t.[ReportDescription] IN (SELECT * FROM @leaveTypeTable))			
	) as ResultSet		
	ORDER BY		
		CASE WHEN @groupBy = 'orgunit2' THEN ResultSet.orgunit2 END,		
		CASE WHEN @groupBy = 'orgunit3' THEN ResultSet.orgunit3 END,
		CASE WHEN @groupBy = 'location' THEN ResultSet.location END,		
		CASE WHEN @groupBy = 'title' OR @sortBy='title' THEN ResultSet.title END,
		CASE WHEN @sortBy = 'displayname' THEN ResultSet.displayname END,		
		CASE WHEN @sortBy = 'duration' THEN ResultSet.total_hour END desc,
		CASE WHEN @sortBy = 'surname' THEN ResultSet.surname END,
		ResultSet.displayname				
			
END
