/****** Object:  Procedure [dbo].[uspGetWorkHourByDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWorkHourByDay] 
	-- Add the parameters for the stored procedure here
	@empID int , @date datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @workHourID int= (SELECT dbo.fnGetWorkHourHeaderIDByDay(@empID, @date));
    -- Insert statements for procedure here
	SELECT isnull(ew.WorkHours,0) as WorkHours
	FROM EmployeeWorkHours ew
	INNER JOIN EmployeeWorkHoursHeader ewh ON ewh.ID= ew.EmployeeWorkHoursHeaderID
	WHERE ewh.ID= @workHourID and ew.DayCode= DATENAME(dw, @date) and ew.Week= dbo.fnGetWeekByHeaderDate(@workHourID, @date)
END

