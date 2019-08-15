/****** Object:  Procedure [dbo].[uspLeaveAnalysisReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspLeaveAnalysisReport] 
	-- Add the parameters for the stored procedure here
	@empID int, @fromDate datetime, @toDate datetime, @chkNotApproveIncluded int, @divisionList varchar(max), @departmentList varchar(max), @locationList varchar(max), @statusList varchar(max), @typeList varchar(max), @leaveTypeList varchar(max), @groupBy varchar(max), @sortBy varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @departmentTable TABLE(department varchar(max));
	DECLARE @divisionTable TABLE(division varchar(max));
	DECLARE @locationTable TABLE(location varchar(max));
	DECLARE @leaveTypeTable TABLE(leaveType varchar(max));
	declare @employeeTypeTable table(employeeType varchar(max));
	declare @employeeStatusTable table(employeeStatus varchar(max));
	--create table #employeeTable (id int, displayname varchar(50), surname varchar(50), location varchar(50), type varchar(50), status varchar(50));
	IF CHARINDEX(',', @divisionList, 0) > 0 BEGIN
		INSERT INTO @divisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionList, ',');	
    END
    ELSE IF LEN(@divisionList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @divisionTable(division) VALUES(@divisionList);	
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

	IF CHARINDEX(',', @leaveTypeList, 0) > 0 BEGIN
		INSERT INTO @leaveTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@leaveTypeList, ',');	
    END
    ELSE IF LEN(@leaveTypeList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @leaveTypeTable(leaveType) VALUES(@leaveTypeList);	
    END	
	IF CHARINDEX(',', @typeList, 0) > 0 BEGIN
		INSERT INTO @employeeTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@typeList, ',');	
    END
    ELSE IF LEN(@typeList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeTypeTable(employeeType) VALUES(@typeList);	
    END	

	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @employeeStatusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusList, ',');	
    END
    ELSE IF LEN(@statusList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeStatusTable(employeeStatus) VALUES(@statusList);	
    END		
    -- Insert statements for procedure here
	SELECT e.id,
	e.displayname as name,
	e.surname,
	e.location as location,
	isnull(p.title,'') as title,
	isnull(p.orgunit2,'') as posorgunit2,
	isnull(p.orgunit3,'') as posorgunit3,
	lr.id as leaveID,
	lr.DateFrom, lr.DateTo,
	--CONCAT (lr.DateFrom,' - ', lr.DateTo) as leaveperiod,
	lt.ReportDescription as leavetype,
	ls.Description as leavestatus,
	--lrd.LeaveDateFrom as leavedate,
	sum(lrd.Duration) as leaveperiodamount,
	lr.TimePeriodRequested as leaveamount
	FROM Employee e
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid= p.id
	INNER JOIN LeaveRequest lr ON e.id= lr.EmployeeID
	INNER JOIN LeaveRequestDetail lrd ON lr.id= lrd.LeaveRequestID
	INNER JOIN LeaveStatus ls ON lr.LeaveStatusID= ls.ID
	INNER JOIN LeaveType lt ON lr.LeaveTypeID= lt.ID
	where ((e.id= @empID) OR @empID=0)
	AND (lrd.LeaveDateFrom>= @fromDate AND lrd.LeaveDateFrom<=@toDate)
	
	AND ((@chkNotApproveIncluded=0 and ls.Code='A') OR (@chkNotApproveIncluded=1 and (ls.Code='P' or ls.Code='A')))
	AND (ls.Code!='C' AND ls.Code!='R')
	AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
	AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
	AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))  
	AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR lt.ReportDescription IN (SELECT * FROM @leaveTypeTable))  
	group by e.id, e.displayname, e.surname, e.location, p.title, p.orgunit2, p.orgunit3, lr.id, lr.DateFrom, lr.DateTo, lt.ReportDescription, ls.Description, lr.TimePeriodRequested 
	ORDER BY		
		CASE WHEN @groupBy = 'posorgunit2' THEN p.orgunit2 END,		
		CASE WHEN @groupBy = 'posorgunit3' THEN p.orgunit3 END,
		CASE WHEN @groupBy = 'location' THEN e.location END,
		CASE WHEN @groupBy = 'title' THEN p.title END,		
		CASE WHEN @groupBy = 'leavestatus' THEN ls.Description END,	
		CASE WHEN @groupBy = 'leavetype' THEN lt.ReportDescription END,	
		CASE WHEN @groupBy = 'surname' THEN e.surname END,
		CASE WHEN @groupBy = 'name' THEN e.displayname END,
						
		CASE WHEN @sortBy = 'posorgunit2' THEN p.orgunit2 END,
		CASE WHEN @sortBy = 'posorgunit3' THEN p.orgunit3 END,
		CASE WHEN @sortBy = 'displayname' THEN e.displayname END,
		CASE WHEN @sortBy = 'title' THEN p.title END,		
		CASE WHEN @sortBy = 'leavestatus' THEN ls.Description END,		
		CASE WHEN @sortBy = 'leavetype' THEN lt.ReportDescription END,			
		CASE WHEN @sortBy = 'surname' THEN e.surname END,		
		CASE WHEN @sortBy = 'name' THEN e.displayname END,
		lr.ID
END

