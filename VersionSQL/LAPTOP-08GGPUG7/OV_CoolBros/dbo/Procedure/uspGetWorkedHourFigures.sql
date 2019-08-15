/****** Object:  Procedure [dbo].[uspGetWorkedHourFigures]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWorkedHourFigures](@empId int, @dateFrom datetime, @dateTo datetime, @takenBreakMinutes decimal(10,5))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @takenBreakMinutes = @takenBreakMinutes / 60;

	DECLARE @headerId int = 0;
	SELECT @headerId = dbo.fnGetWorkHourHeaderIDByDay(@empId, @dateFrom);

	DECLARE @allowOvertime bit;
	DECLARE @ExtraHoursPayType int;
	SELECT @allowOvertime = AllowOvertime, @ExtraHoursPayType = ExtraHoursPayType FROM EmployeeWorkHoursHeader WHERE id = @headerId;

	DECLARE @startTimeDate datetime;
	DECLARE @endTimeDate datetime;
	DECLARE @breakMinutes decimal(10,5);
	DECLARE @overtimeStartsAfter decimal(10,5);
	DECLARE @extraHours decimal(10,5);
	DECLARE @enabled bit;

	SELECT 
		@startTimeDate = StartDateTime,
		@endTimeDate = EndDateTime,
		@breakMinutes = BreakMinutes,
		@overtimeStartsAfter = OvertimeStartsAfter,
		@extraHours = ExtraHours,
		@enabled = [Enabled]
	FROM
		dbo.fnGetWorkDayData(@empId, @dateFrom, @headerId);

	SET @breakMinutes = ISNULL(@breakMinutes / 60, 0)

	DECLARE @workDayHours decimal(10,5) = dbo.fnGetHoursInDay(@empId, @dateFrom) - @breakMinutes
	--SET @workDayHours += @extraHours;

	DECLARE @timeWorked decimal(10,5) = (CAST(DATEDIFF(minute, @dateFrom, @dateTo) as float) / 60) - @takenBreakMinutes

	DECLARE @extraWorked decimal(10,5);
	SET @extraWorked = @timeWorked - dbo.fnGetHoursInDay(@empId, @dateFrom)
	IF ISNULL(@extrahours, 0) = 0
		SET @extraWorked = 0;
	ELSE IF @extraWorked > @extraHours
		SET @extraWorked = @extraHours
	ELSE IF @extraWorked < 0
		SET @extraWorked = 0

	DECLARE @overtimeWorked decimal(10,5) = 0;
	IF @timeWorked > @overtimeStartsAfter AND @allowOvertime = 1
		SET @overtimeWorked = @timeWorked - @overtimeStartsAfter
	IF @overtimeWorked < 0
		SET @overtimeWorked = 0;


	--IF @allowOvertime = 0 BEGIN
	--	SET @overtimeWorked = 0;
	--	IF @timeWorked > @workDayHours BEGIN
	--		SET @timeWorked = @workDayHours
	--	END
	--END

	SELECT 
		@timeWorked AS WorkHours,
		@timeWorked as TotalHours,
		@overtimeWorked as OvertimeHours,
		@overtimeStartsAfter as OvertimeAfterHours,
		@enabled AS [Enabled],
		@extraWorked as ExtraWorked

END

