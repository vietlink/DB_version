/****** Object:  Procedure [dbo].[uspUpdateEmployeeWorkHoursHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeeWorkHoursHeader](@headerId int, @holidayRegionId int, @salary decimal(18,2), @dateFrom datetime, @dateTo datetime, @weekMode int,
	@isReturningEmployee bit, @payRollCycle int, @enableTimesheet bit, @enableProjectTimesheet bit, @enableSwipeCard bit, @timesheetTimeMode int, @projectTimeMode int, @defaultRecordingMethod int, @allowAutoApproval bit,
	@defaultProjectID int, @defaultTaskID int, @timeShiftLoadingHeaderID int, @allowOVertime bit, @normalOvertimeRate int, @overtimeStartsAfter decimal, @defaultOvertimeTo int, @applyOvertimeOption int,
	@startBuffer decimal(10, 5), @finishBuffer decimal(10, 5), @maxToilBalance decimal(10,5), @extraHoursPayType int, @noApprovalForLeave bit, @noApprovalForTimesheet bit, @noApprovalForExpense bit, @paycostcentreid int, @expensecostcentreid int,
	@moduleTimesheet bit, @moduleLeave bit, @moduleExpense bit, @capHours bit)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @empId int = 0;
	SELECT @empId = EmployeeID FROM EmployeeWorkHoursHeader WHERE ID = @headerId;

	DECLARE @currentId int;
	SELECT TOP 1 @currentId = id FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND ID <> @headerId AND (DateFrom < @dateFrom AND DateTo IS NULL) ORDER BY dateFrom DESC
	IF @currentId IS NULL
		SELECT TOP 1 @currentId = id FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND ID <> @headerId AND (DateFrom <= @dateFrom) ORDER BY dateFrom DESC

	UPDATE EmployeeWorkHoursHeader SET DateTo = DATEADD(day,-1, @dateFrom) WHERE id = @currentId;

    UPDATE
		EmployeeWorkHoursHeader
	SET
		HolidayRegionID = @holidayRegionId,
		SalaryBase = @salary,
		DateFrom = @dateFrom,
		DateTo = @dateTo,
		WeekMode = @weekMode,
		PayRollCycle = @payRollCycle,
		IsReturningEmployee = @isReturningEmployee,
		EnableTimesheet = @enableTimesheet, 
		EnableProjectTimesheet = @enableProjectTimesheet,
		TimesheetTimeMode = @timesheetTimeMode,
		ProjectTimeMode = @projectTimeMode,
		DefaultRecordingMethod = @defaultRecordingMethod,
		AllowAutoApproval = @allowAutoApproval,
		DefaultProjectID = @defaultProjectID,
		DefaultTaskID = @defaultTaskID,
		TimeShiftLoadingHeaderID = @timeShiftLoadingHeaderID,
		AllowOvertime = @allowOvertime,
		NormalOvertimeRate = @normalOvertimeRate,
		OvertimeStartsAfter = @overtimeStartsAfter,
		DefaultOvertimeTo = @defaultOvertimeTo,
		ApplyOvertimeOption = @applyOvertimeOption,
		StartBuffer = @startBuffer,
		FinishBuffer = @finishBuffer,
		MaxToilBalance = @maxToilBalance,
		EnableSwipeCard = @enableSwipeCard,
		ExtraHoursPayType = @extraHoursPayType,
		NoApprovalForLeave = @noApprovalForLeave,
		NoApprovalForTimesheet = @noApprovalForTimesheet,
		NoApprovalForExpense = @noApprovalForExpense,
		PayCostCentreID = @payCostCentreID,
		ExpenseCostCentreID = @expenseCostCentreID,
		ModuleTimesheet = @moduleTimesheet,
		ModuleLeave = @moduleLeave,
		ModuleExpense = @moduleExpense,
		CapHours = @capHours
	WHERE
		id = @headerId;
END
