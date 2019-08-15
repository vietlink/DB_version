/****** Object:  Procedure [dbo].[uspValidateWorkHourHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspValidateWorkHourHeader](@empId int, @dateFrom datetime, @dateTo datetime, @headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @compareDateFrom datetime;
	DECLARE @compareDateTo datetime;

	IF @headerId = 0 BEGIN
		SELECT TOP 1 @compareDateFrom = [DateFrom], @compareDateTo = [DateTo] FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId ORDER BY [DateFrom] DESC;
		IF @dateTo <= @compareDateFrom 
			RETURN -1; -- end date must be greater than previous start date
		IF @dateFrom <= @compareDateFrom
			RETURN -3;
	END
	ELSE BEGIN
		DECLARE @comparePrevDateFrom datetime;
		DECLARE @compareNextDateFrom datetime;
		DECLARE @comparePrevDateTo datetime;
		DECLARE @compareNextDateTo datetime

		SELECT TOP 1 @comparePrevDateFrom = [DateFrom], @comparePrevDateTo = [DateTo] FROM EmployeeWorkHoursHeader 
			WHERE employeeid = @empId AND id < @headerId
			ORDER BY id desc

		SELECT TOP 1 @compareNextDateFrom = [DateFrom], @compareNextDateTo = [DateTo] FROM EmployeeWorkHoursHeader 
			WHERE employeeid = @empId AND id > @headerId
			ORDER BY id asc

		IF @compareNextDateTo IS NOT NULL AND @dateFrom >=  @compareNextDateTo
			RETURN -2; -- cant be greater than next end

		IF @dateFrom <= @comparePrevDateFrom
			RETURN -3;

		IF @dateFrom >= @compareNextDateFrom
			RETURN -4;

		IF @dateTo IS NOT NULL AND
		@dateTo >= @compareNextDateTo AND @compareNextDateFrom IS NOT NULL
			RETURN -5;
		IF @dateTo IS NULL AND @compareNextDateTo IS NOT NULL
			RETURN -5;
	END

	RETURN 0;
END

