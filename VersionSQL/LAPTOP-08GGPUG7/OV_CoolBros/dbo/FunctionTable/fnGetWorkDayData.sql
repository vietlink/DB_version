/****** Object:  Function [dbo].[fnGetWorkDayData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetWorkDayData](@empId int, @date datetime, @currentWorkHoursHeaderID int)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		ewh.StartDateTime,
		ewh.EndDateTime,
		ISNULL(ewh.OvertimeStartsAfter, 0) AS OvertimeStartsAfter,
		ISNULL(ewh.BreakMinutes, 0) as BreakMinutes,
		ISNULL(ewh.ExtraHours, 0) as ExtraHours,
		ewh.Enabled
	FROM
		EmployeeWorkHours ewh
	WHERE 
		ewh.EmployeeID = @empID AND ewh.EmployeeWorkHoursHeaderID = @currentWorkHoursHeaderID 
		AND ewh.DayCode = DATENAME(dw, @date) AND ewh.[week] = dbo.fnGetWeekByHeaderDate(@currentWorkHoursHeaderID, @date)
)

