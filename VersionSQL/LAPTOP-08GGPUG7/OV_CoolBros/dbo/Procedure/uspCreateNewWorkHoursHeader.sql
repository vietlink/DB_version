/****** Object:  Procedure [dbo].[uspCreateNewWorkHoursHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateNewWorkHoursHeader](@empId int, @startDate datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @currentId int;
	SELECT TOP 1 @currentId = id FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND (DateFrom < @startDate AND DateTo IS NULL) ORDER BY dateFrom DESC
	IF @currentId IS NULL
		SELECT TOP 1 @currentId = id FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND (DateFrom <= @startDate) ORDER BY dateFrom DESC

	IF NOT EXISTS (SELECT ID FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND DateFrom = @startDate) BEGIN
		UPDATE EmployeeWorkHoursHeader SET DateTo = DATEADD(day,-1, @startDate) WHERE id = @currentId;

		INSERT INTO EmployeeWorkHoursHeader(EmployeeID, DateFrom, DateTo, SalaryBase, TimeShiftLoadingHeaderID)
			VALUES(@empId, @startDate, NULL, 0, NULL)

		RETURN @@IDENTITY;
	END

	RETURN -1;
END
