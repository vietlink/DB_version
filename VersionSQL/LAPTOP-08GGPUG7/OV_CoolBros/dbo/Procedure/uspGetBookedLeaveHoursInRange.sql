/****** Object:  Procedure [dbo].[uspGetBookedLeaveHoursInRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetBookedLeaveHoursInRange](@empId int, @leaveTypeId int, @dateFrom DateTime, @dateTo DateTime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		SUM(lrd.Duration) as Duration
	FROM
		LeaveRequestDetail lrd
	INNER JOIN
		LeaveRequest lr
	ON
		lr.id = lrd.LeaveRequestID
	WHERE
		lr.IsCancelled = 0 AND lr.LeaveTypeID = @leaveTypeId AND lr.EmployeeID = @empId AND lrd.LeaveDateFrom >= @dateFrom AND lrd.LeaveDateTo <= @dateTo
    
END

