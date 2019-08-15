/****** Object:  Procedure [dbo].[uspValidateStatusHistoryDates]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspValidateStatusHistoryDates](@employeeId int, @historyid int, @startDate datetime, @endDate datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @compareStartDate datetime;
	DECLARE @compareEndDate datetime;

	IF @historyid = 0 BEGIN
		SELECT TOP 1 @compareStartDate = StartDate, @compareEndDate = EndDate FROM EmployeeStatusHistory WHERE EmployeeID = @employeeId ORDER BY StartDate DESC;
		IF @endDate <= @compareStartDate 
			RETURN -1; -- end date must be greater than previous start date
		IF @startDate <= @compareStartDate
			RETURN -3;
	END
	ELSE BEGIN
		DECLARE @comparePrevStartDate datetime;
		DECLARE @compareNextStartDate datetime;
		DECLARE @comparePrevEndDate datetime;
		DECLARE @compareNextEndDate datetime

		SELECT TOP 1 @comparePrevStartDate = StartDate, @comparePrevEndDate = EndDate FROM EmployeeStatusHistory 
			WHERE employeeid = @employeeid AND id < @historyid
			ORDER BY id desc

		SELECT TOP 1 @compareNextStartDate = StartDate, @compareNextEndDate = EndDate FROM EmployeeStatusHistory 
			WHERE employeeid = @employeeid AND id > @historyid
			ORDER BY id asc

		IF @compareNextEndDate IS NOT NULL AND @startDate >=  @compareNextEndDate
			RETURN -2; -- cant be greater than next end

		IF @startDate <= @comparePrevStartDate
			RETURN -3;

		IF @startDate >= @compareNextStartDate
			RETURN -4;

		IF @endDate IS NOT NULL AND
		@endDate >= @compareNextEndDate AND @compareNextStartDate IS NOT NULL
			RETURN -5;
		IF @endDate IS NULL AND @compareNextEndDate IS NOT NULL
			RETURN -5;
	END

	RETURN 0;
END


