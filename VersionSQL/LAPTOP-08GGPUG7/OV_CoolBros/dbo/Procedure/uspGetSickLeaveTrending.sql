/****** Object:  Procedure [dbo].[uspGetSickLeaveTrending]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSickLeaveTrending] 
	-- Add the parameters for the stored procedure here
	@idList varchar(max), @fromDate datetime, @toDate datetime, @chkIncludecheck int, @isCommencement int, @divisionFilter varchar(max), @departmentFilter varchar(max), @positionFilter varchar(max), @locationFilter varchar(max), @groupBy VARCHAR(MAX), @sortBy VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @idTable TABLE(id int);
	DECLARE @divisionTable TABLE(division varchar(max));
	DECLARE @departmentTable TABLE(department varchar(max));
	DECLARE @positionTable TABLE(position varchar(max));
	DECLARE @locationTable TABLE(location varchar(max));
	--DECLARE @employeeStatusTable TABLE(employeeStatus varchar(max));	

	IF CHARINDEX(',', @idList, 0) > 0 BEGIN
		INSERT INTO @idTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@idList, ',');	
    END
    ELSE IF LEN(@idList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idTable(id) VALUES(CAST(@idList AS int)) ;	
    END

	IF CHARINDEX(',', @divisionFilter, 0) > 0 BEGIN
		INSERT INTO @divisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionFilter, ',');	
    END
    ELSE IF LEN(@divisionFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @divisionTable(division) VALUES(@divisionFilter);	
    END
	
	IF CHARINDEX(',', @departmentFilter, 0) > 0 BEGIN
		INSERT INTO @departmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentFilter, ',');	
    END
    ELSE IF LEN(@departmentFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @departmentTable(department) VALUES(@departmentFilter);	
    END

	IF CHARINDEX(';', @locationFilter, 0) > 0 BEGIN
		INSERT INTO @locationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationFilter, ';');	
    END
    ELSE IF LEN(@locationFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @locationTable(location) VALUES(@locationFilter);	
    END

	IF CHARINDEX(',', @positionFilter, 0) > 0 BEGIN
		INSERT INTO @positionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@positionFilter, ',');	
    END
    ELSE IF LEN(@positionFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @positionTable(position) VALUES(@positionFilter);	
    END	
    -- Insert statements for procedure here
SELECT * FROM(
	SELECT
	E.id AS EmpID, EP.ID AS EmpPosID, E.displayname, E.commencement, E.surname, E.location, E.Status, P.id AS PosID, P.title, P.orgunit2 AS posorgunit2, P.orgunit3 AS posorgunit3	

	,isnull(sum(CASE WHEN DATENAME(dw, LRD.LeaveDateFrom) = 'Monday' THEN isnull(lrd.duration/dbo.fnGetHoursInDay(E.id, lrd.leavedatefrom),0) END),0) AS Mon
	,isnull(sum(CASE WHEN DATENAME(dw, LRD.LeaveDateFrom) = 'Tuesday' THEN isnull(lrd.duration/dbo.fnGetHoursInDay(E.id, lrd.leavedatefrom),0) END),0) AS Tues
	,isnull(sum(CASE WHEN DATENAME(dw, LRD.LeaveDateFrom) = 'Wednesday' THEN isnull(lrd.duration/dbo.fnGetHoursInDay(E.id, lrd.leavedatefrom),0) END),0) AS Wed
	,isnull(sum(CASE WHEN DATENAME(dw, LRD.LeaveDateFrom) = 'Thursday' THEN isnull(lrd.duration/dbo.fnGetHoursInDay(E.id, lrd.leavedatefrom),0) END),0) AS Thurs
	,isnull(sum(CASE WHEN DATENAME(dw, LRD.LeaveDateFrom) = 'Friday' THEN isnull(lrd.duration/dbo.fnGetHoursInDay(E.id, lrd.leavedatefrom),0) END),0) AS Fri
	,isnull(sum(CASE WHEN DATENAME(dw, LRD.LeaveDateFrom) = 'Saturday' THEN isnull(lrd.duration/dbo.fnGetHoursInDay(E.id, lrd.leavedatefrom),0) END),0) AS Sat
	,isnull(sum(CASE WHEN DATENAME(dw, LRD.LeaveDateFrom) = 'Sunday' THEN isnull(lrd.duration/dbo.fnGetHoursInDay(E.id, lrd.leavedatefrom),0) END),0) AS Sun
	,sum(isnull(lrd.duration/dbo.fnGetHoursInDay(e.id, lrd.leavedatefrom),0)) AS Total

	,SUM( IIF( dbo.fnGetHoursInDay(E.ID, DATEADD(day, -1, LR.DateFrom)) is null 				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
				, 1/dbo.fnGetDaysFromLeaveRequest(lr.id), 0) ) as NonWorkDayPrior -- NWD before sick leave

	,SUM( IIF( dbo.fnIsNWDInRange(E.id, LR.DateFrom, DATEADD(day,1,LR.DateTo))=1 
				AND [dbo].[fnCheckAnnualLeaveOnDay](E.ID,DATEADD(day, -1, LR.DateFrom)) = 0
				AND dbo.fnIsPublicHolidayOnDay(DATEADD(day, -1, LR.DateFrom), lrd.employeeworkhoursheaderid)=0
				AND dbo.fnGetHoursInDay(E.ID, DATEADD(day, -1, LR.DateFrom)) is NOT null, 
				1/dbo.fnGetDaysFromLeaveRequest(lr.id),0) ) as NonWorkDayAfter -- NWD after sick leave

	,SUM( IIF( dbo.fnIsPublicHolidayOnDay(DATEADD(day, -1, LR.DateFrom), lrd.employeeworkhoursheaderid)>0				
				, 1/dbo.fnGetDaysFromLeaveRequest(lr.id), 0) ) as PublicHolidayPrior --public holiday before sick leave

	,SUM( IIF( [dbo].[fnIsPublicHolidayInRange](E.id, LR.DateFrom, DATEADD(day,1,LR.DateTo))=1 
				AND [dbo].[fnCheckAnnualLeaveOnDay](E.ID,DATEADD(day, -1, LR.DateFrom)) = 0
				AND dbo.fnIsPublicHolidayOnDay(DATEADD(day, -1, LR.DateFrom), lrd.employeeworkhoursheaderid)=0
				AND dbo.fnGetHoursInDay(E.ID, DATEADD(day, -1, LR.DateFrom)) is NOT null, 
				1/dbo.fnGetDaysFromLeaveRequest(lr.id), 0) ) as PublicHolidayAfter -- public holiday after sick leave

	,SUM( IIF( [dbo].[fnCheckAnnualLeaveOnDay](E.ID,DATEADD(day, -1, LR.DateFrom)) = 1 , 
				1/dbo.fnGetDaysFromLeaveRequest(lr.id), 0 )) as AnnualLeavePrior -- annual leave before sick leave

	,SUM( IIF( dbo.fnIsAnnualLeaveInRange(E.id, LR.DateFrom, DATEADD(day, 1,LR.DateTo)) = 1 
				AND [dbo].[fnCheckAnnualLeaveOnDay](E.ID,DATEADD(day, -1, LR.DateFrom)) = 0
				AND dbo.fnIsPublicHolidayOnDay(DATEADD(day, -1, LR.DateFrom), lrd.employeeworkhoursheaderid)=0
				AND dbo.fnGetHoursInDay(E.ID, DATEADD(day, -1, LR.DateFrom)) is NOT null, 
				1/dbo.fnGetDaysFromLeaveRequest(lr.id), 0 )) as AnnualLeaveAfter -- annual leave after sick leave

FROM
	LeaveRequest LR
	INNER JOIN LeaveRequestDetail LRD ON LRD.LeaveRequestID = LR.ID
	INNER JOIN EmployeePosition EP ON EP.EmployeeID = LR.EmployeeID AND EP.primaryposition = 'y' AND EP.IsDeleted = 0
	INNER JOIN Position P ON EP.PositionID = P.ID
	INNER JOIN Employee E on LR.EmployeeID = E.ID
	INNER JOIN LeaveType LT ON LR.LeaveTypeID = lt.ID	
	INNER JOIN LeaveStatus ls ON ls.ID=lr.LeaveStatusID
WHERE 
	LT.SystemCode = 'S' 
	AND lr.IsCancelled = 0 
	AND (ls.code<>'C' AND ls.code<>'R')
	AND ((@isCommencement = 0 AND lrd.leavedatefrom >= @fromDate AND lrd.leavedatefrom <= @toDate) OR(@isCommencement = 1 AND e.commencement<= lrd.leavedatefrom))
	AND ((@chkIncludeCheck = 1 AND (ls.code = 'A' OR ls.code = 'P')) OR (@chkIncludecheck = 0 AND ls.code ='A'))
	AND ((SELECT COUNT(*) FROM @positionTable) = 0 OR P.title IN (SELECT * FROM @positionTable))		
	AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(P.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(P.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(E.location, '(Blank)') IN (SELECT * FROM @locationTable))
	AND ((SELECT COUNT(*) FROM @idTable) = 0 OR E.id IN (SELECT * FROM @idTable))
	
GROUP BY E.id, EP.id, E.displayname, E.commencement, E.surname, E.location, E.status, P.id, P.title, P.orgunit2, P.orgunit3) AS Result
ORDER BY		
		CASE WHEN @groupBy = 'posorgunit2' THEN Result.posorgunit2 END,		
		CASE WHEN @groupBy = 'posorgunit3' THEN Result.posorgunit3 END,
		CASE WHEN @groupBy = 'location' THEN Result.location END,		
		CASE WHEN @groupBy = 'title' THEN Result.title END,		

		CASE WHEN @sortBy = 'sickleavedesc' THEN Result.Total END DESC,
		CASE WHEN @sortBy = 'sickleaveasc' THEN Result.Total END ASC,
		CASE WHEN @sortBy = 'orgunit3' THEN Result.posorgunit3 END,
		CASE WHEN @sortBy = 'name' THEN Result.displayname END,
		CASE WHEN @sortBy = 'surname' THEN Result.surname END					
END

