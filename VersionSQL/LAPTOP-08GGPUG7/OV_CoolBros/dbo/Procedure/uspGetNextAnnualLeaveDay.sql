/****** Object:  Procedure [dbo].[uspGetNextAnnualLeaveDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetNextAnnualLeaveDay](@empId int, @hourHeaderId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1
		lr.DateFrom,
		lr.DateTo,
		lr.TimePeriodRequested as period,
		ISNULL(dbo.fnGetDaysFromLeaveHours(@empId, lr.id), 0) as Days
	FROM
		LeaveRequest lr
	INNER JOIN
		LeaveRequestDetail lrd
	ON
		lr.id = lrd.LeaveRequestID
	INNER JOIN
		LeaveType t
	ON
		lr.LeaveTypeID = t.id
	INNER JOIN
		LeaveStatus s
	ON
		lr.LeaveStatusID = s.id
	WHERE
		lr.IsCancelled = 0 AND
		s.Code = 'A' AND t.LeaveClassify = 1 AND (lrd.LeaveDateFrom >= Convert(DateTime, DATEDIFF(DAY, 0, GETDATE())) OR lrd.LeaveDateTo >= Convert(DateTime, DATEDIFF(DAY, 0, GETDATE())))
		AND lr.EmployeeID = @empId
	ORDER BY lrd.LeaveDateFrom ASC
END
