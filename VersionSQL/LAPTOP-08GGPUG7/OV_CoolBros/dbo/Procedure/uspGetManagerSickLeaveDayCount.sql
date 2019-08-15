/****** Object:  Procedure [dbo].[uspGetManagerSickLeaveDayCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetManagerSickLeaveDayCount](@managerEmpId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT
		ISNULL(SUM(CASE WHEN DATENAME(dw, lrd.LeaveDateFrom) = 'Monday' THEN 1 ELSE 0 END), 0) as Monday,
		ISNULL(SUM(CASE WHEN DATENAME(dw, lrd.LeaveDateFrom) = 'Tuesday' THEN 1 ELSE 0 END), 0) as Tuesday,
		ISNULL(SUM(CASE WHEN DATENAME(dw, lrd.LeaveDateFrom) = 'Wednesday' THEN 1 ELSE 0 END), 0) as Wednesday,
		ISNULL(SUM(CASE WHEN DATENAME(dw, lrd.LeaveDateFrom) = 'Thursday' THEN 1 ELSE 0 END), 0) as Thursday,
		ISNULL(SUM(CASE WHEN DATENAME(dw, lrd.LeaveDateFrom) = 'Friday' THEN 1 ELSE 0 END), 0) as Friday,
		ISNULL(SUM(CASE WHEN DATENAME(dw, lrd.LeaveDateFrom) = 'Saturday' THEN 1 ELSE 0 END), 0) as Saturday,
		ISNULL(SUM(CASE WHEN DATENAME(dw, lrd.LeaveDateFrom) = 'Sunday' THEN 1 ELSE 0 END), 0) as Sunday
	FROM
		LeaveRequest lr
	INNER JOIN
		LeaveRequestDetail lrd
	ON
		lrd.LeaveRequestID = lr.ID
	INNER JOIN 
		LeaveType t 
	ON 
		lr.LeaveTypeID = t.ID
	INNER JOIN
		LeaveStatus s
	ON
		lr.LeaveStatusID = s.id
	INNER JOIN
		Employee e
	ON
		e.ID = lr.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0
	INNER JOIN
		EmployeePosition epM
	ON
		epM.EmployeeID = @managerEmpId AND epM.id = ep.ManagerID
	WHERE lr.IsCancelled = 0 AND t.code = 'S' AND s.code <> 'C'

END

