/****** Object:  Function [dbo].[fnGetStartTimeOnDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetStartTimeOnDay](@empId int, @date datetime)
RETURNS DateTime
AS
BEGIN
	DECLARE @currentWorkHoursHeaderID int = dbo.fnGetWorkHourHeaderIDByDay(@empId, @date);
	
	DECLARE @startTime datetime;
	SELECT
		@startTime = ewh.StartDateTime
	FROM
		EmployeeWorkHours ewh
	WHERE 
		ewh.EmployeeID = @empID AND ewh.EmployeeWorkHoursHeaderID = @currentWorkHoursHeaderID 
		AND ewh.DayCode = DATENAME(dw, @date) AND [Enabled] = 1 AND ewh.[week] = dbo.fnGetWeekByHeaderDate(@currentWorkHoursHeaderID, @date)

	RETURN @startTime

END

