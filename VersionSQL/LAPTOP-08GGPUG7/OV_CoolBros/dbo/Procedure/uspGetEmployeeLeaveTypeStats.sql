/****** Object:  Procedure [dbo].[uspGetEmployeeLeaveTypeStats]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeLeaveTypeStats](@empId int, @headerId int, @date date)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		elt.EmployeeID,
		lt.*,
		dbo.fnGetTotalAccrualCount(@date, @empId, elt.LeaveTypeID) as TotalHours,
		dbo.fnGetAverageDayWorkHours(@empId, @headerId) as AverageHours 
	FROM
		EmployeeLeaveTypes elt
	INNER JOIN
		LeaveType lt
	ON
		lt.ID = elt.LeaveTypeID
	WHERE
		EmployeeID = @empId AND EmployeeWorkHoursHeaderID = @headerId AND elt.[Enabled] = 1
END

