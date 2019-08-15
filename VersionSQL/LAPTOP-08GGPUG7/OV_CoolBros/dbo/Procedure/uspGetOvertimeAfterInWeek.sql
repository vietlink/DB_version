/****** Object:  Procedure [dbo].[uspGetOvertimeAfterInWeek]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetOvertimeAfterInWeek](@empId int, @date datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @headerId int;
	SELECT @headerId = dbo.fnGetWorkHourHeaderIDByDay(@empId, @date);

	DECLARE @result decimal(18,8)
	SELECT @result = SUM(OvertimeStartsAfter) FROM EmployeeWorkHours WHERE EmployeeID = @empId AND EmployeeWorkHoursHeaderID = @headerId AND [week] = dbo.fnGetWeekByHeaderDate(@headerId, @date);
	
	SELECT ISNULL(@result, 0) as [Hours]
END

