/****** Object:  Function [dbo].[fnGetAverageDayWorkHours]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetAverageDayWorkHours](@empId int, @dateHeaderId int)
RETURNS decimal(12,9)
AS
BEGIN
	DECLARE @result decimal(12,9);
	
	SELECT @result = ISNULL((SUM(WorkHours) / COUNT(id)), 0.0) FROM EmployeeWorkHours WHERE [Enabled] = 1 AND EmployeeID = @empId AND EmployeeWorkHoursHeaderID = @dateHeaderId
	RETURN @result;
END

