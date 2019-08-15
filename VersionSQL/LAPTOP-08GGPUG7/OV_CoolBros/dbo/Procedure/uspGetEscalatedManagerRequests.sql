/****** Object:  Procedure [dbo].[uspGetEscalatedManagerRequests]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEscalatedManagerRequests](@managerEmpId int, @managerPosId int, @dateFrom datetime, @dateTo datetime, @typeFilterList varchar(max), @statusList varchar(max), @sortBy varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idTable TABLE(id int);
	DECLARE @tempIdTable TABLE(id int);
	DECLARE @classTable TABLE(classId int);
	DECLARE @statusTable TABLE(status varchar(max));

	IF CHARINDEX(',', @typeFilterList, 0) > 0 BEGIN
		INSERT INTO @tempIdTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@typeFilterList, ',');
	--	INSERT INTO @idTable SELECT @publicHolidayTypeID;
    END
    ELSE IF LEN(@typeFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @tempIdTable(id) VALUES(CAST(@typeFilterList AS int));
	--	INSERT INTO @idTable SELECT @publicHolidayTypeID;
    END
	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @statusTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusList, ',');	
    END
    ELSE IF LEN(@statusList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @statusTable(status) VALUES(@statusList);	
    END	
	IF LEN(@typeFilterList) > 0 BEGIN
		INSERT INTO @classTable
		SELECT 
			LeaveClassify
		FROM
			LeaveType
		WHERE ID IN (SELECT * FROM @tempIdTable) AND LeaveClassify <> 5 -- need to remove all other types as these don't group

		INSERT INTO @idTable
		SELECT
			ID
		FROM
			LeaveType
		WHERE
			LeaveClassify IN (SELECT * FROM @classTable)

		INSERT INTO @idTable
		SELECT
			ID
		FROM
			LeaveType
		WHERE ID IN (SELECT * FROM @tempIdTable) AND LeaveClassify = 5 -- bring back the selected 'others'

	END
	DECLARE @NWD TABLE (empID int, _date datetime, isWorkDay int)
DECLARE @empIDs TABLE (id int, displayname varchar(max), firstname varchar(max), surname varchar(max), positionID int, empposID int, title varchar(max), epMposID int, ApprovalLevel int)


SELECT
		r.EmployeeID,
		p.id as PositionID,
		ep.id as EpID,
		'' as Title,
		t.[Description] as LeaveType,
		t.Code as LeaveTypeCode,
		t.BackgroundColour,
		t.FontColour,
		s.[Description] as LeaveStatus,
		--s.ShortDescription as LeaveStatusShortDescription,
		r.ReasonForLeave,
		r.LeaveContactDetails,
		r.ApproverComments,
		r.TimePeriodRequested,
		lrd.LeaveDateFrom as DateFrom,
		lrd.LeaveDateTo as DateTo,
		r.ExclWeekends,
		r.ExclPublicHolidays,
		ewh.WorkHours,
		dbo.fnGetHoursFromLeaveRequest(e.id, r.id) as ActualHours,
		dbo.fnGetDaysFromLeaveHours(e.id, r.id) as Days,
		r.ID as RequestID,
		e.displayname, 
		e.surname, e.firstname,
		p.title as position,
		lrd.duration,
		s.shortdescription as leavestatusshortdescription,
		t.ReportDescription,
		ew.HolidayRegionID INTO #escalatedLeave
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
		EmployeeWorkHoursHeader ew
	ON 
		ewh.EmployeeWorkHoursHeaderID= ew.ID
	INNER JOIN
		Employee e
	ON
		e.ID = r.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0 and ep.primaryposition = 'Y'
	LEFT OUTER JOIN
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
		ewh.EmployeeWorkHoursHeaderID = r.EmployeeWorkHoursHeaderID
		AND ewh.DayCode = DATENAME(dw, lrd.LeaveDateFrom) 
		AND ewh.[Enabled] = 1
		AND ewh.[week] = dbo.fnGetWeekByHeaderDate(r.EmployeeWorkHoursHeaderID, lrd.LeaveDateFrom) 
		AND	lrd.LeaveDateFrom >= @dateFrom AND lrd.LeaveDateFrom <= @dateTo
		AND ((SELECT COUNT(*) FROM @idTable) = 0 OR r.LeaveTypeID IN (SELECT * FROM @idTable))
		
		AND ls.Code = 'P'
		AND 
		(
			(t.ApprovalLevel < 3 AND
			(	
				(t.Escalate1ID = @managerPosId OR t.Escalate2ID = @managerPosId)
				OR
				(t.Approver2 = 1 AND epM.id IN (SELECT * FROM dbo.fnGetChildrenIDsByManagerID(@managerEmpId)))
				OR
				(t.Approver2 = 2 AND epM.id IN (SELECT * FROM dbo.fnGetChildrenIDsBySupervisorID(@managerPosId)))
			))
			OR
			(t.ApprovalLevel = 3 AND (p.ApprovalLevel = 2 OR t.overridepositionlevel = 1) AND
			(	
				(t.Escalate1ID = @managerPosId OR (R.Approver1EPID IS NOT NULL AND t.Escalate2ID = @managerPosId))
				OR
				(R.Approver1EPID IS NOT NULL AND t.Approver2 = 1 AND epM.id IN (SELECT * FROM dbo.fnGetChildrenIDsByManagerID(@managerEmpId)))
				OR
				(R.Approver1EPID IS NOT NULL AND t.Approver2 = 2 AND epM.id IN (SELECT * FROM dbo.fnGetChildrenIDsBySupervisorID(@managerPosId)))
			))
		)
INSERT INTO @empIDs
	SELECT e.id, e.displayname, e.firstname, e.surname, p.id as positionID, ep.id, p.title, epM.positionid as positionMid, p.ApprovalLevel
	FROM Employee e 
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid= p.id
	LEFT OUTER JOIN EmployeePosition epM ON epM.id = ep.ManagerID
	
	INNER JOIN #escalatedLeave el ON e.id= el.EmployeeID
	
	--and e.id in (select e.EmployeeID from #escalatedLeave e)

DECLARE @currentID int
DECLARE c CURSOR FOR SELECT id FROM @empIDs
OPEN c
FETCH FROM c INTO @currentID
WHILE @@FETCH_STATUS=0
	BEGIN
		DECLARE @currentDate datetime= @dateFrom
		WHILE (@currentDate <= @dateTo) BEGIN
			DECLARE @hour decimal = isnull (dbo.fnGetHoursInDay(@currentID, @currentDate),0)
			declare @leaveID int = isnull((SELECT TOP 1 p.RequestID FROM #escalatedLeave p WHERE p.DateFrom= @currentDate and p.EmployeeID= @currentID),0)
			IF (@hour = 0 and @leaveID=0) BEGIN
				INSERT INTO @NWD VALUES (@currentID, @currentDate, 0)
			END ELSE IF (@hour !=0 and @leaveID!=0) BEGIN 
				INSERT INTO @NWD VALUES (@currentID, @currentDate, 2)				
			END ELSE IF (@hour !=0 and @leaveID=0) BEGIN
				INSERT INTO @NWD VALUES (@currentID, @currentDate, 1)
			END ELSE BEGIN
				INSERT INTO @NWD VALUES (@currentID, @currentDate, 2)
				
			END
			SET @currentDate = DATEADD(day, 1, @currentDate);
		END
		FETCH FROM c INTO @currentID
	END
CLOSE c;
DEALLOCATE c;
--select * from @empIDs
--select * from #escalatedLeave
SELECT * FROM (
    SELECT * FROM #escalatedLeave
UNION
	SELECT
		e.id as EmployeeID,
		e.positionID as PositionID,
		e.empposID as EpID,
		'' as Title,
		'NWD' as LeaveType,
		'' as LeaveTypeCode,
		'' as BackgroundColour,
		'' as FontColour,
		'' as LeaveStatus,
		--s.ShortDescription as LeaveStatusShortDescription,
		'' as ReasonForLeave,
		'' as LeaveContactDetails,
		'' as ApproverComments,
		0 as TimePeriodRequested,
		n._date as DateFrom,
		n._date as DateTo,
		0 as ExclWeekends,
		0 as ExclPublicHolidays,
		0 as WorkHours,
		0 as ActualHours,
		0 as Days,
		0 as RequestID,
		e.displayname, 
		e.surname, e.firstname,
		e.title as position,
		0 as duration,
		'' as leavestatusshortdescription,
		'' as ReportDescription,
		0 as HolidayRegionID
	FROM		
		@empIDs e	
	INNER JOIN
		@NWD n
	ON e.id= n.empID
	WHERE n.isWorkDay=0
UNION	
	SELECT
		e.id as EmployeeID,
		e.positionID as PositionID,
		e.empposID as EpID,
		'' as Title,
		'WD' as LeaveType,
		'' as LeaveTypeCode,
		'' as BackgroundColour,
		'' as FontColour,
		'' as LeaveStatus,
		--s.ShortDescription as LeaveStatusShortDescription,
		'' as ReasonForLeave,
		'' as LeaveContactDetails,
		'' as ApproverComments,
		0 as TimePeriodRequested,
		n._date as DateFrom,
		n._date as DateTo,
		0 as ExclWeekends,
		0 as ExclPublicHolidays,
		0 as WorkHours,
		0 as ActualHours,
		0 as Days,
		0 as RequestID,
		e.displayname, 
		e.surname, e.firstname,
		e.title as position,
		0 as duration,
		'' as leavestatusshortdescription,
		'' as ReportDescription,
		0 as HolidayRegionID
	FROM				
		EmployeeWorkHours ewh	
	INNER JOIN EmployeeWorkHoursHeader ew 
	ON
		ewh.EmployeeWorkHoursHeaderID= ew.ID
	INNER JOIN
		@empIDs e	
	ON 
		ewh.EmployeeID= e.id
	INNER JOIN @NWD n ON e.id= n.empID and n.isWorkDay=1		
	WHERE dbo.fnGetWorkHourHeaderIDByDay(e.id, n._date)=ew.id
	and dbo.fnGetWeekByHeaderDate(ew.ID, n._date)=ewh.Week
	and ewh.DayCode = DATENAME(dw, n._date)
	and dbo.fnIsPublicHolidayOnDay(n._date, ew.ID)=0
UNION
	SELECT
		e.id as EmployeeID,
		e.positionID as PositionID,
		e.empposID as EpID,
		'' as Title,
		'P' as LeaveType,
		'' as LeaveTypeCode,
		'' as BackgroundColour,
		'' as FontColour,
		'' as LeaveStatus,
		--s.ShortDescription as LeaveStatusShortDescription,
		'' as ReasonForLeave,
		'' as LeaveContactDetails,
		'' as ApproverComments,
		0 as TimePeriodRequested,
		n._date as DateFrom,
		n._date as DateTo,
		0 as ExclWeekends,
		0 as ExclPublicHolidays,
		0 as WorkHours,
		0 as ActualHours,
		0 as Days,
		0 as RequestID,
		e.displayname, 
		e.surname, e.firstname,
		e.title as position,
		0 as duration,
		'' as leavestatusshortdescription,
		'' as ReportDescription,
		0 as HolidayRegionID
	FROM
		
		EmployeeWorkHours ewh	
	INNER JOIN EmployeeWorkHoursHeader ew 
	ON
		ewh.EmployeeWorkHoursHeaderID= ew.ID
	INNER JOIN
		@empIDs e	
	ON 
		ewh.EmployeeID= e.id
	INNER JOIN @NWD n ON e.id= n.empID and n.isWorkDay=1
	INNER JOIN 
		HolidayRegion hr
	ON
		ew.HolidayRegionID= hr.ID
	INNER JOIN 
		Holiday h
	ON hr.ID= h.HolidayRegionID AND ewh.DayCode = DATENAME(dw, h.Date) and dbo.fnGetWorkHourHeaderIDByDay(e.id, h.Date)=ew.id
	, LeaveType lt
	WHERE lt.SystemCode='P'
	and h.Date=n._date
	and dbo.fnGetWeekByHeaderDate(ew.ID, n._date)=ewh.Week
	and ewh.DayCode = DATENAME(dw, n._date)
	) as Result		
	ORDER BY 
		CASE WHEN @sortBy = 'displayname' THEN Result.displayname END,
		CASE WHEN @sortBy = 'surname' THEN Result.surname END,		
		CASE WHEN @sortBy='title' THEN Result.title END,
		Result.datefrom asc, Result.surname, Result.firstname, Result.EmployeeID
	if (OBJECT_ID('tempdb..#escalatedLeave') is not null)			
		drop table #escalatedLeave
END
