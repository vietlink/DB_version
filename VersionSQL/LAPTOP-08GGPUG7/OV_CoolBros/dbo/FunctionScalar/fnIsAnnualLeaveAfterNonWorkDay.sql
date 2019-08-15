/****** Object:  Function [dbo].[fnIsAnnualLeaveAfterNonWorkDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnIsAnnualLeaveAfterNonWorkDay](@empId int, @date DateTime)
RETURNS bit
AS
BEGIN

	-- Find the last annual leave in a 2 week range
	DECLARE @nextAnnualLeave DateTime;
	SELECT 
		@nextAnnualLeave = MIN(lrd.LeaveDateFrom)
	FROM 
		LeaveRequest lr
	INNER JOIN 
		LeaveRequestDetail lrd 
	ON 
		lr.id = lrd.LeaveRequestID 
	INNER JOIN
		LeaveType lt 
	ON 
		lr.LeaveTypeID = lt.ID
	INNER JOIN 
		LeaveStatus ls
	ON
		ls.id = lr.LeaveStatusID
	WHERE
		(lt.SystemCode = 'A' OR lt.SystemCode='AL')
		AND lrd.leaveDatefrom >= @date AND lrd.LeaveDateFrom < DATEADD(day, 14, @date) AND lr.EmployeeID = @empID
		AND lr.IsCancelled = 0
		AND ls.Code<>'R' AND ls.Code <> 'C'
	-- No leave found so exit with false
	IF @nextAnnualLeave IS NULL
		RETURN 0;


	-- Create a fake date range between the last annual leave and check date
	DECLARE @dateTable TABLE ([date] DateTime);

	DECLARE @StartDate DateTime = @date
	DECLARE @EndDate DateTime = DATEADD(day, -1, @nextAnnualLeave);

	INSERT INTO @dateTable SELECT  DATEADD(DAY, nbr - 1, @StartDate)
	FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY c.object_id ) AS Nbr
				FROM      sys.columns c
			) nbrs
	WHERE   nbr - 1 <= DATEDIFF(DAY, @StartDate, @EndDate)
	
	-- Sum up hours between last annual leave and check date
	DECLARE @hoursInDay decimal(18, 8);
	SELECT
		@hoursInDay = ISNULL(SUM(dbo.fnGetHoursInDay(@empId, dt.[date])), 0.0)
	FROM
		@dateTable dt

	-- annual leave was found, no hours between now and sick leave, so return true
	IF @hoursInDay = 0
		RETURN 1;
	
	RETURN 0;

END

