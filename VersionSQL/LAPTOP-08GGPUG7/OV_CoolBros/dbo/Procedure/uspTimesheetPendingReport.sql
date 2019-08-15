/****** Object:  Procedure [dbo].[uspTimesheetPendingReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspTimesheetPendingReport] 
	-- Add the parameters for the stored procedure here
	@empID int, @paycycleID int, @fromDate datetime, @toDate datetime, @notCreatedIncluded int, @divisionList varchar(max), @statusList varchar(max), @departmentList varchar(max), @locationList varchar(max), @empStatus varchar(max), @groupBy varchar(max), @sortBy varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @divisionTable TABLE(division varchar(max));
	DECLARE @statusTable TABLE(status varchar(max));
	DECLARE @empstatusTable TABLE(status varchar(max));
	DECLARE @departmentTable TABLE(department varchar(max));	
	DECLARE @locationTable TABLE(location varchar(max));
	--DECLARE @employeeStatusTable TABLE(employeeStatus varchar(max));	
	

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

	IF CHARINDEX(',', @empStatus, 0) > 0 BEGIN
		INSERT INTO @empstatusTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@empStatus, ',');	
    END
    ELSE IF LEN(@empStatus) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @empstatusTable(status) VALUES(@empStatus);	
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
SELECT * FROM (
	SELECT isnull(ts.ID,0) AS timesheetID,
	e.id AS empID,
	e.displayname AS name,
	e.surname,
	e.status,
	isnull(pc.Description,'') AS payCycle,	
	ISNULL(p.title, '') AS title,
	ISNULL(p.orgunit2, '(Blank)') AS posorgunit2,
	isnull(p.orgunit3,'(Blank)') AS posorgunit3,
	isnull(e.location, '(Blank)') AS location,
	isnull(dbo.fnGetTimesheetSubmitteDate(ts.ID),'') AS SubmittedDate,
	isnull(dbo.fnGetTimesheetApprover(ep.id),'') AS TimesheetApprover,
	isnull(dbo.fnGetTimesheetApproverID(ep.id),0) AS TimesheetApproverID,
	isnull(dbo.fnGetTOILApprover(ep.id),'') AS TOILApprover,
	isnull(dbo.fnGetTOILApproverID(ep.id),0) AS TOILApproverID,
	'Timesheet' AS type,
	isnull(s.Description,'') AS TimesheetStatus,
	isnull(s.Code,'') AS statusCode,
	isnull(ts.payrollcycleID,0) AS cycleID,
	ts.RequiresAdditionalApproval AS AdditionalApprove
	FROM  Employee e	
	INNER JOIN TimesheetHeader ts ON e.id = ts.EmployeeID 	
	INNER JOIN EmployeeWorkHoursHeader ewh ON e.id= ewh.EmployeeID
	INNER JOIN PayrollCycleGroups pc1 ON ewh.PayRollCycle= pc1.ID
	INNER JOIN PayrollCycle pc ON ts.PayrollCycleID = pc.ID
	INNER JOIN TimesheetStatus s ON ts.TimesheetStatusID = s.ID
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid= p.id			
	WHERE 
	ts.IsTimesheetApproved=0
	and (((pc.ID= @paycycleID) AND (@paycycleID!=0)) OR (@paycycleID=0))	 
	and ep.vacant='N'
	and e.status<>'Deleted'
	and e.IsPlaceholder!=1	
	AND ((e.id = @empID AND @empID!=0) OR (@empID=0))		
	AND ((s.Code IN (SELECT * FROM @statusTable)))
UNION
	SELECT 0 AS timesheetID,
	e.id AS empID,
	e.displayname AS name,
	e.surname,
	e.status,
	'' AS payCycle,	
	ISNULL(p.title, '') AS title,
	ISNULL(p.orgunit2, '(Blank)') AS posorgunit2,
	isnull(p.orgunit3,'(Blank)') AS posorgunit3,
	isnull(e.location, '(Blank)') AS location,
	'' AS SubmittedDate,
	isnull(dbo.fnGetTimesheetApprover(ep.id),'') AS TimesheetApprover,
	isnull(dbo.fnGetTimesheetApproverID(ep.id),0) AS TimesheetApproverID,
	isnull(dbo.fnGetTOILApprover(ep.id),'') AS TOILApprover,
	isnull(dbo.fnGetTOILApproverID(ep.id),0) AS TOILApproverID,
	'Timesheet' AS type,
	'Not Created' AS TimesheetStatus,
	'n' AS statusCode,
	ewh.PayRollCycle,
	0 AS AdditionalApprove
	FROM  Employee e	
	INNER JOIN EmployeeWorkHoursHeader ewh ON e.id= ewh.EmployeeID AND ewh.id=dbo.fnGetWorkHeaderInPeriod(e.id, @fromDate, @toDate)
	INNER JOIN PayrollCycleGroups pc1 ON ewh.PayRollCycle= pc1.ID
	INNER JOIN PayrollCycle pc ON pc1.ID= pc.PayrollCycleGroupID and pc.id=@paycycleID
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid= p.id
	--LEFT OUTER JOIN TimesheetHeader ts ON e.id = ts.EmployeeID 	
	--LEFT OUTER JOIN PayrollCycle pc ON pc1.ID= pc.PayrollCycleGroupID 
	--LEFT OUTER JOIN TimesheetStatus s ON ts.TimesheetStatusID = s.ID
	WHERE 
	e.id not in (select ts.EmployeeID from TimesheetHeader ts 
	INNER JOIN PayrollCycle pc ON ts.PayrollCycleID=pc.ID
	INNER JOIN TimesheetStatus s ON ts.TimesheetStatusID = s.ID where pc.ID=@paycycleID )
	--AND (pc.ID=68 or pc.ID is null)
	
	--AND (pc.FromDate>=@fromDate AND pc.ToDate<=@toDate)
	and ep.vacant='N'
	and e.status<>'Deleted'
	and e.IsPlaceholder!=1	
	AND ((e.id = @empID AND @empID!=0) OR (@empID=0))	
	AND @notCreatedIncluded=1
UNION
	SELECT isnull(ts.ID,0) AS timesheetID,
	e.id AS empID,
	e.displayname AS name,
	e.surname,
	e.status,
	isnull(pc.Description,'') AS payCycle,	
	ISNULL(p.title, '') AS title,
	ISNULL(p.orgunit2, '(Blank)') AS posorgunit2,
	isnull(p.orgunit3,'(Blank)') AS posorgunit3,
	isnull(e.location, '(Blank)') AS location,
	dbo.fnGetTimesheetSubmitteDate(ts.ID)AS SubmittedDate,
	isnull(dbo.fnGetTimesheetApprover(ep.id),'') AS TimesheetApprover,
	isnull(dbo.fnGetTimesheetApproverID(ep.id),0) AS TimesheetApproverID,
	isnull(dbo.fnGetTOILApprover(ep.id),'') AS TOILApprover,
	isnull(dbo.fnGetTOILApproverID(ep.id),0) AS TOILApproverID,
	'Additional Hrs' AS type,
	isnull(s.Description,'') AS TimesheetStatus,
	isnull(s.Code,'') AS statusCode,
	isnull(ts.payrollcycleID,0) AS cycleID,
	ts.RequiresAdditionalApproval AS AdditionalApprove
	FROM  Employee e	
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid= p.id
	INNER JOIN TimesheetHeader ts ON e.id = ts.EmployeeID 	
	INNER JOIN PayrollCycle pc ON ts.PayrollCycleID = pc.ID
	INNER JOIN TimesheetStatus s ON ts.TimesheetStatusID = s.ID
	--INNER JOIN TimesheetRateAdjustment tra on ts.ID= tra.TimesheetHeaderID
	WHERE 	
	ts.IsAdditionalApproved=0
	and ts.RequiresAdditionalApproval=1
	and ts.OvertimeHours>0
	and ep.vacant='N'
	and e.status<>'Deleted'
	and e.IsPlaceholder!=1	
	AND (((pc.ID= @paycycleID) AND (@paycycleID!=0)) OR (@paycycleID=0))
	AND ((e.id = @empID AND @empID!=0) OR (@empID=0))	
	
	AND ((s.Code IN (SELECT * FROM @statusTable)))
	) AS Result
WHERE
	((SELECT COUNT(*) FROM @departmentTable) = 0 OR Result.posorgunit3 IN (SELECT * FROM @departmentTable))	
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR Result.posorgunit2 IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR Result.location IN (SELECT * FROM @locationTable))
	AND ((SELECT COUNT(*) FROM @empstatusTable) = 0 OR Result.status IN (SELECT * FROM @empstatusTable))
	
ORDER BY
	CASE WHEN @groupBy = 'posorgunit2' THEN Result.posorgunit2 END,		
		CASE WHEN @groupBy = 'posorgunit3' THEN Result.posorgunit3 END,		
		CASE WHEN @groupBy = 'title' THEN Result.title END,		
		CASE WHEN @groupBy = 'timesheetStatus' THEN Result.TimesheetStatus END,				
		CASE WHEN @groupBy = 'name' THEN Result.name END,	
		CASE WHEN @groupBy = 'location' THEN Result.location END,	
		CASE WHEN @groupBy = 'timesheetApprover' THEN Result.TimesheetApprover END,	
		CASE WHEN @groupBy = 'type' THEN Result.type END,	
		CASE WHEN @groupBy = 'paycycle' THEN Result.payCycle END,

		CASE WHEN @sortBy = 'name' THEN Result.name END,		
		CASE WHEN @sortBy = 'surname' THEN Result.surname END,
		CASE WHEN @sortBy = 'posorgunit2' THEN Result.posorgunit2 END,		
		CASE WHEN @sortBy = 'posorgunit3' THEN Result.posorgunit3 END,	
		CASE WHEN @sortBy = 'timesheetApprover' THEN Result.TimesheetApprover END,	
		CASE WHEN @sortBy = 'paycycle' THEN Result.payCycle END,
		CASE WHEN @sortBy = 'type' THEN Result.type END,	
		CASE WHEN @sortBy = 'timesheetStatus' THEN Result.TimesheetStatus END,		
		Result.timesheetID
END

