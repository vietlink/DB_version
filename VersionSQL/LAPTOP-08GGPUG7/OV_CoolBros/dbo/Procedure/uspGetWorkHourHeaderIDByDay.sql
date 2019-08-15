/****** Object:  Procedure [dbo].[uspGetWorkHourHeaderIDByDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWorkHourHeaderIDByDay](@empId int, @date datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @id int;

	SELECT @id = ISNULL(id, 0) FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND ((@date >= DateFrom AND @date <= cast(convert(char(8), DateTo, 112) + ' 23:59:59.99' as datetime))
	OR (@date >= DateFrom AND DateTo IS NULL))
	ORDER BY DateFrom DESC

	RETURN @id;
END

