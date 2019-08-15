/****** Object:  Function [dbo].[fnGetHoursInWeek]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetHoursInWeek](@empId int, @date datetime)
RETURNS decimal(18,8)
AS
BEGIN
	DECLARE @headerId int;
	SELECT @headerId = dbo.fnGetWorkHourHeaderIDByDay(@empId, @date);

	DECLARE @result decimal(18,8)
	SELECT @result = SUM(WorkHours) FROM EmployeeWorkHours WHERE EmployeeID = @empId AND EmployeeWorkHoursHeaderID = @headerId AND [week] = dbo.fnGetWeekByHeaderDate(@headerId, @date);

	return @result;
END

