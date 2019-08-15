/****** Object:  Procedure [dbo].[uspGetCurrentHolidayRegion]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetCurrentHolidayRegion](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @id int;
	SELECT @id = ISNULL(HolidayRegionID, 0) FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND DateFrom <= GETDATE()
	ORDER BY DateFrom DESC

	RETURN @id;
	
END

