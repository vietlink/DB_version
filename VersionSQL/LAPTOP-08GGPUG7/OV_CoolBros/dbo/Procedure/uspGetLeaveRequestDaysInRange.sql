/****** Object:  Procedure [dbo].[uspGetLeaveRequestDaysInRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveRequestDaysInRange](@empId int, @dateFrom datetime, @dateTo datetime, @headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @reportDesc varchar(100) = '';
	SELECT @reportDesc = ReportDescription FROM LeaveType WHERE SystemCode = 'P'

	DECLARE @holidayRegionId int = 0;
	SELECT @holidayRegionId = HolidayRegionID FROM EmployeeWorkHoursHeader WHERE ID = @headerId

    SELECT
		lrd.LeaveDateFrom,
		lrd.Duration,
		lt.ReportDescription as ReportDescription,
		ls.Code
	FROM
		LeaveRequestDetail lrd
	INNER JOIN
		LeaveRequest lr
	ON
		lrd.LeaveRequestID = lr.ID
	INNER JOIN
		LeaveStatus ls
	ON
		lr.LeaveStatusID = ls.ID
	INNER JOIN
		LeaveType lt
	ON
		lr.LeaveTypeID = lt.ID
	WHERE	
		lr.EmployeeID = @empId AND (ls.Code = 'A' OR ls.Code = 'P') AND lrd.LeaveDateFrom >= @dateFrom AND lrd.LeaveDateFrom <= @dateTo
--	ORDER BY
	--	lt.ReportDescription

	UNION
	SELECT
		h.[Date] as LeaveDateFrom,
		ISNULL(dbo.fnGetHoursInDay(@empId, h.[Date]), 0) as Duration,
		@reportDesc As ReportDescription,
		'H' as Code
	FROM
		Holiday h
	WHERE
		HolidayRegionID = @holidayRegionId AND h.[Date] >= @dateFrom AND h.[Date] <= @dateTo

	ORDER BY
		ReportDescription
		
END

