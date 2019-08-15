/****** Object:  Procedure [dbo].[uspGetLeaveSummary1]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Viet Linh
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveSummary1] 
	-- Add the parameters for the stored procedure here
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

	IF CHARINDEX(',', @locationFilterList, 0) > 0 BEGIN
		INSERT INTO @idLocationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationFilterList, ',');	
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
	create table #temp1(
	EmployeeID int, PositionID int, LeaveType varchar(50), LeaveID int, LeaveStatus varchar(50), LeaveDescription varchar (50),
	DateFrom datetime, DateTo datetime, RequestID int, DisplayName varchar (50), duration decimal, leaveCode varchar, 
	department varchar(50), division varchar(50), location varchar (50), BookedLeave int)
	create table #temp2(
	division varchar(50), department varchar(50), location varchar(50), _id int, LeaveType varchar (50))

	insert into #temp1
	SELECT distinct
		r.EmployeeID as EmployeeID,
		p.ID as PositionID,		
		t.[ReportDescription] as LeaveType,	
		t.ID as LeaveID,
		s.[Description] as LeaveStatus,
		s.ShortDescription as LeaveDescription,	
		lrd.LeaveDateFrom as DateFrom,
		lrd.LeaveDateTo as DateTo,
		r.ID as RequestID,
		e.displayname as DisplayName,
		lrd.duration as duration,
		s.Code as leavestatusshortdescription,
		p.orgunit3 as department,
		p.orgunit2 as division,
		p.location as location,
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
		EmployeeWorkHours ewh
	ON
	 	ewh.EmployeeID = r.EmployeeID 
	INNER JOIN
		Employee e
	ON
		e.ID = r.EmployeeID
		INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0
	INNER JOIN
		EmployeePosition epM
	ON
		epM.id = ep.ManagerID
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID
	INNER JOIN
		LeaveStatus ls
	ON
		ls.id = r.LeaveStatusID
	WHERE
		r.IsCancelled = 0 AND
		ewh.EmployeeWorkHoursHeaderID = r.EmployeeWorkHoursHeaderID AND
		ewh.[week] = dbo.fnGetWeekByHeaderDate(lrd.EmployeeWorkHoursHeaderID, lrd.LeaveDateFrom) AND
		lrd.LeaveDateFrom >= @dateFrom AND lrd.LeaveDateFrom <= @dateTo
		AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable))
		AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR p.location IN (SELECT * FROM @idLocationTable))
		AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR t.[ReportDescription] IN (SELECT * FROM @leaveTypeTable))		
		
	insert into #temp2
	select distinct p.orgunit2, p.orgunit3, p.location, t.ID, t.Description
	from position p, LeaveType t
	where t.Enabled=1
	AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable))
		AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR p.location IN (SELECT * FROM @idLocationTable))
		AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR t.[ReportDescription] IN (SELECT * FROM @leaveTypeTable))

	select  #temp1.RequestID, #temp2.*, 
	#temp1.EmployeeID, #temp1.DisplayName, 
	#temp1.leaveCode, #temp1.LeaveStatus,  	
	#temp1.DateFrom, #temp1.DateTo, #temp1.duration, #temp1.BookedLeave	
	from #temp2 left join #temp1 
	on #temp2.department=#temp1.department and #temp2.division=#temp1.division and #temp2.location= #temp1.location and #temp2._id=#temp1.LeaveID
	ORDER BY		
		CASE WHEN @groupBy = 'division' THEN #temp2.division END,		
		CASE WHEN @groupBy = 'department' THEN #temp2.department END,
		CASE WHEN @sortBy = 'displayname' THEN #temp1.DisplayName END,		
		CASE WHEN @sortBy = 'duration' THEN #temp1.duration END
		DESC
	drop table #temp1, #temp2
END

