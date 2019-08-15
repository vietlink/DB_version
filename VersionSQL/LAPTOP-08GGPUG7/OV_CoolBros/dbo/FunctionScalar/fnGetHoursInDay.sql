/****** Object:  Function [dbo].[fnGetHoursInDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetHoursInDay](@empId int, @date datetime)
RETURNS decimal(18, 8)
AS
BEGIN
	DECLARE @currentWorkHoursHeaderID int = dbo.fnGetWorkHourHeaderIDByDay(@empId, @date);
	
	DECLARE @hoursInDay decimal(18, 8);
	SELECT
		@hoursInDay = ISNULL(WorkHours, 0.0)
	FROM
		EmployeeWorkHours ewh
	WHERE 
		ewh.EmployeeID = @empID AND ewh.EmployeeWorkHoursHeaderID = @currentWorkHoursHeaderID 
		AND ewh.DayCode = DATENAME(dw, @date) AND [Enabled] = 1 AND ewh.[week] = dbo.fnGetWeekByHeaderDate(@currentWorkHoursHeaderID, @date)

	RETURN @hoursInDay

END

