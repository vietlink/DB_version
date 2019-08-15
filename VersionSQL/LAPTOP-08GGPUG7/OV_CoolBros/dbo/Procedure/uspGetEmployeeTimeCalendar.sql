/****** Object:  Procedure [dbo].[uspGetEmployeeTimeCalendar]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeTimeCalendar](@empId int, @dateFrom datetime, @dateTo datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @holidayTypeId int = 0;
	SELECT @holidayTypeId = id FROM LeaveType WHERE code = 'P';

	DECLARE @dateTable TABLE ([date] DateTime);

	DECLARE @StartDate DATE = @dateFrom;
	DECLARE @EndDate DATE = @dateTo;

	INSERT INTO @dateTable SELECT  DATEADD(DAY, nbr - 1, @StartDate)
	FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY c.object_id ) AS Nbr
			  FROM      sys.columns c
			) nbrs
	WHERE   nbr - 1 <= DATEDIFF(DAY, @StartDate, @EndDate)

	SELECT
		pc.ID as payrollcycleid, dt.[date], ps.Code as PayRollStatusCode, td.[Hours] AS [Hours],
		'' as backgroundcolour, '' as fontcolour, NULL as [description], 0 as id, ewh.id, ISNULL(dbo.fnGetHoursInDay(@empId, dt.date), 0) as HoursInDay, 1 as sort, th.islocked,
		tss.code as statuscode
	FROM
		@dateTable dt
	INNER JOIN
		EmployeeWorkHoursHeader ewh
	ON
		ewh.DateFrom <= dt.[date] AND ISNULL(ewh.DateTo, '2222-01-01') >= dt.[date]
	INNER JOIN
		PayrollCycleGroups pcg
	ON
		pcg.ID = ewh.PayRollCycle
	LEFT OUTER JOIN
		PayrollCycle pc
	ON
		pc.PayrollCycleGroupID = pcg.ID AND (pc.FromDate <= dt.[date] AND pc.ToDate >= dt.[date]) AND pc.IsDeleted = 0
	LEFT OUTER JOIN
		PayrollStatus ps
	ON
		ps.ID = pc.PayrollStatusID
	LEFT OUTER JOIN
		TimesheetHeader th
	ON
		th.EmployeeID = ewh.EmployeeID AND PayrollCycleID = pc.ID
	LEFT OUTER JOIN
		TimesheetDay td
	ON
		td.TimesheetHeaderID = th.ID AND td.[Date] = dt.[date]
	LEFT OUTER JOIN
		TimeSheetStatus tss
	ON
		tss.ID = th.TimesheetStatusID
	WHERE
		ewh.EmployeeID = @empId
	UNION ALL
	SELECT
		pc.ID as payrollcycleid, dt.[date], ps.Code as PayRollStatusCode, lrd.duration [Hours],
		lt.backgroundcolour, lt.fontcolour, NULL as description, lrd.id, ewh.id, ISNULL(dbo.fnGetHoursInDay(@empId, dt.date), 0) as HoursInDay, 2 as sort, th.islocked, tss.code as statuscode
	FROM
		@dateTable dt
	INNER JOIN
		EmployeeWorkHoursHeader ewh
	ON
		ewh.DateFrom <= dt.[date] AND ISNULL(ewh.DateTo, '2222-01-01') >= dt.[date]
	INNER JOIN
		PayrollCycleGroups pcg
	ON
		pcg.ID = ewh.PayRollCycle
	LEFT OUTER JOIN
		PayrollCycle pc
	ON
		pc.PayrollCycleGroupID = pcg.ID AND (pc.FromDate <= dt.[date] AND pc.ToDate >= dt.[date]) AND pc.IsDeleted = 0
	LEFT OUTER JOIN
		PayrollStatus ps
	ON
		ps.ID = pc.PayrollStatusID
	LEFT OUTER JOIN
		TimesheetHeader th
	ON
		th.EmployeeID = ewh.EmployeeID AND PayrollCycleID = pc.ID
	LEFT OUTER JOIN
		TimesheetDay td
	ON
		td.TimesheetHeaderID = th.ID AND td.[Date] = dt.[date]
	INNER JOIN
		LeaveRequest lr
	ON
		lr.ID IN (SELECT id FROM dbo.fnGetLeaveIDsByDate(td.[Date], ewh.ID))
	INNER JOIN
		LeaveRequestDetail lrd
	ON
		lrd.LeaveRequestID = lr.ID AND lrd.LeaveDateFrom = td.[Date]
	INNER JOIN
		LeaveType lt
	ON
		lt.ID = lr.LeaveTypeID
	LEFT OUTER JOIN
		TimeSheetStatus tss
	ON
		tss.ID = th.TimesheetStatusID
	WHERE
		ewh.EmployeeID = @empId
	UNION ALL
	SELECT
		pc.ID as payrollcycleid, dt.[date], ps.Code as PayRollStatusCode, 0 [Hours],
		lt.backgroundcolour, lt.fontcolour, h.[description], 0 as id, ewh.id, ISNULL(dbo.fnGetHoursInDay(@empId, dt.date), 0) as HoursInDay, 3 as sort, th.islocked as islocked, tss.code as statuscode
	FROM
		@dateTable dt
	INNER JOIN
		EmployeeWorkHoursHeader ewh
	ON
		ewh.DateFrom <= dt.[date] AND ISNULL(ewh.DateTo, '2222-01-01') >= dt.[date]
	INNER JOIN
		PayrollCycleGroups pcg
	ON
		pcg.ID = ewh.PayRollCycle
	LEFT OUTER JOIN
		PayrollCycle pc
	ON
		pc.PayrollCycleGroupID = pcg.ID AND (pc.FromDate <= dt.[date] AND pc.ToDate >= dt.[date]) AND pc.IsDeleted = 0
	LEFT OUTER JOIN
		TimesheetHeader th
	ON
		th.EmployeeID = ewh.EmployeeID AND PayrollCycleID = pc.ID
	LEFT OUTER JOIN
		PayrollStatus ps
	ON
		ps.ID = pc.PayrollStatusID
	INNER JOIN
		Holiday h
	ON
		h.ID = dbo.fnIsPublicHolidayOnDay(dt.[Date], ewh.ID)
	INNER JOIN
		LeaveType lt
	ON
		lt.ID = @holidayTypeID
	LEFT OUTER JOIN
		TimeSheetStatus tss
	ON
		tss.ID = th.TimesheetStatusID
	WHERE
		ewh.EmployeeID = @empId AND h.HolidayRegionID = ewh.HolidayRegionID
	ORDER BY [date], sort
END

