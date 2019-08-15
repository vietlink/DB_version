/****** Object:  Function [dbo].[fnGetEmployeeWorkedHoursInRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetEmployeeWorkedHoursInRange](@empId int, @dateHeaderId int, @from datetime, @to datetime)
RETURNS int
AS
BEGIN
	DECLARE @result decimal(10,5);
	SELECT
		@result = ISNULL(SUM(cs.DayCount * ewh.WorkHours), 0) 
	FROM
		EmployeeWorkHours ewh
	INNER JOIN
		fnGetDayCountsInRange(@from, @to) cs
	ON
		cs.[Day] = ewh.DayCode
	WHERE 
		ewh.EmployeeID = @empId AND ewh.EmployeeWorkHoursHeaderID = @dateHeaderId AND ewh.[Enabled] = 1 --AND [week] = dbo.fnGetWeekByHeaderDate(ewh.EmployeeWorkHoursHeaderID, lrd.LeaveDateFrom)

	RETURN @result;
END

