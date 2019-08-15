/****** Object:  Procedure [dbo].[uspGetHoursInDayWithWeek]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetHoursInDayWithWeek](@empId int, @dayOfWeek varchar(20), @date datetime, @week int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @dateHeaderId int = 0;
	EXEC @dateHeaderId = dbo.uspGetWorkHourHeaderIDByDay @empId, @date
    SELECT * FROM EmployeeWorkHours WHERE EmployeeID = @empId AND DayCode = @dayOfWeek AND EmployeeWorkHoursHeaderID = @dateHeaderId
	AND [week] = @week
END

