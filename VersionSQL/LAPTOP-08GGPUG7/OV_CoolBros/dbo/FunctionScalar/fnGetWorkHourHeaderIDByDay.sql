/****** Object:  Function [dbo].[fnGetWorkHourHeaderIDByDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetWorkHourHeaderIDByDay](@empId int, @date datetime)
RETURNS int
AS
BEGIN
    DECLARE @id int;

	SELECT @id = ISNULL(id, 0) FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND ((@date >= DateFrom AND @date <= cast(convert(char(8), DateTo, 112) + ' 23:59:59.99' as datetime))
	OR (@date >= DateFrom AND DateTo IS NULL))
	ORDER BY DateFrom DESC

	RETURN @id;

END

