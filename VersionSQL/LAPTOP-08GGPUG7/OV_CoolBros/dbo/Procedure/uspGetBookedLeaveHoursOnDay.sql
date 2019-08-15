/****** Object:  Procedure [dbo].[uspGetBookedLeaveHoursOnDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetBookedLeaveHoursOnDay](@empId int, @date DateTime, @paid bit, @headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @duration decimal(18,2)

	SELECT
		@duration = ISNULL(SUM(lrd.Duration), 0)
	FROM
		LeaveRequestDetail lrd
	INNER JOIN
		LeaveRequest lr
	ON
		lr.id = lrd.LeaveRequestID
	INNER JOIN
		EmployeeWorkHoursHeader ewh
	ON
		lr.EmployeeWorkHoursHeaderID = ewh.ID
	INNER JOIN
		LeaveType lt
	ON
		lr.LeaveTypeID = lt.ID
	INNER JOIN
		LeaveStatus ls
	ON
		ls.ID = lr.LeaveStatusID
	LEFT OUTER JOIN
		Holiday h
	ON
		h.HolidayRegionID = ewh.HolidayRegionID AND h.[date] = @date
	WHERE
		lr.IsCancelled = 0 AND lr.EmployeeID = @empId AND lrd.LeaveDateFrom = @date AND ((@paid = 0 AND lt.PaidLeave = 0) OR ((ls.Code = 'A' OR ls.Code = 'P') AND lt.PaidLeave = @paid));

	DECLARE @holidayHours decimal(18,2) = 0;

	IF @paid = 1 BEGIN
		SELECT
			@holidayHours = (CASE WHEN h.ID IS NULL THEN 0 ELSE dbo.fnGetHoursInDay(@empId, @date) END)
		FROM
			EmployeeWorkHoursHeader ewh
		LEFT OUTER JOIN
			Holiday h
		ON
			h.HolidayRegionID = ewh.HolidayRegionID AND h.[date] = @date
		WHERE
			ewh.ID = @headerId
	END

	SELECT (@duration + ISNULL(@holidayHours, 0)) as Duration
END

