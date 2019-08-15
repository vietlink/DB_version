/****** Object:  Procedure [dbo].[uspGetBookedLeaveProjection]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetBookedLeaveProjection](@empId int, @leaveTypeId int, @dateFrom DateTime, @dateTo DateTime, @actualEndDate DateTime, @excludeId int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- @actualEndDate was needed for the work hours, need to get at end date rather than between now and start as at

	DECLARE @dateHeaderId int;
	EXEC @dateHeaderId = dbo.uspGetWorkHourHeaderIDByDay @empId, @dateFrom

	DECLARE @rate decimal(18,10) = dbo.fnGetAccrueHoursByLeaveType(@leaveTypeId);
	DECLARE @averageHours decimal(12,9) = dbo.fnGetAverageDayWorkHours(@empId, @dateHeaderId)

	declare @totalHoursWorked decimal(10,5) = dbo.fnGetEmployeeWorkedHoursInRange(@empId, @dateHeaderId, DATEADD(day, 1, @dateFrom), @actualEndDate)
	
	declare @totalHoursBooked decimal(10,5) = 0;
	--if(@dateFrom > @dateTo)
	--	set @totalHoursBooked = dbo.fnGetBookedHoursInRange(@empId, @dateTo, DATEADD(year, 2, @dateTo), @leaveTypeId, @excludeId)
	--else
	set @totalHoursBooked = dbo.fnGetBookedHoursInRange(@empId, @dateTo, DATEADD(year, 2, @actualEndDate), @leaveTypeId, @excludeId)
		
	DECLARE @totalAccrued decimal(18,8) = dbo.fnGetTotalAccrualCount(@dateTo, @empId, @leaveTypeId);
	
	DECLARE @pendingPrior decimal(18,8) = dbo.fnGetPendingHoursPrior(@empId, @dateTo, @leaveTypeId, @excludeId);

	DECLARE @pendingFuture decimal(18,8) = 0;
	DECLARE @approvedFuture decimal(18,8) = 0;
	--@empId int, @from datetime, @leaveTypeId int, @code varchar(5))
--	IF @excludeId = -1 BEGIN
		SET @pendingFuture = dbo.fnGetFutureHoursByCode(@empId, @dateFrom, @leaveTypeId, 'P');
		SET @approvedFuture = dbo.fnGetFutureHoursByCode(@empId, @dateFrom, @leaveTypeId, 'A');
	--END

	DECLARE @allowNegative bit;
	DECLARE @negativeTolerance decimal(10,5);
	DECLARE @minimumLeave decimal(10,5);
	DECLARE @maximumLeave decimal(10,5);
	DECLARE @reportdescription varchar(100);
	DECLARE @accrueLeave bit;
	DECLARE @reasonRequired bit;
	DECLARE @allowDocuments bit;
	SELECT @maximumLeave = MaximumLeave, @allowDocuments = AllowDocuments, @reasonRequired = ReasonRequired, @reportdescription = ReportDescription, @accrueLeave = AccrueLeave, @minimumLeave = minimumLeave, @allowNegative = allowNegative, @negativeTolerance = negativeTolerance FROM LeaveType WHERE ID = @leaveTypeId;

	SELECT isnull(@totalAccrued, 0) as TotalHoursAccrued,
	isnull(@totalHoursWorked, 0) AS TotalHoursWorked,
	isnull(@totalHoursWorked, 0) * isnull(@rate, 0) As TotalAccruedProjectedHours,
	ISNULL(@totalHoursBooked, 0) as TotalBookedHours,
	isnull(@averageHours, 0) as AverageHoursPerDay,
	ISNULL(@pendingPrior, 0)  as TotalPendingPrior,
	isnull(@allowNegative, 0) AS AllowNegative,
	isnull(@negativeTolerance, 0) as NegativeTolerance,
	isnull(@minimumLeave, 0) as MinimumLeave,
	@reportdescription as reportdescription,
	isnull(@pendingfuture, 0) as PendingFuture,
	isnull(@approvedfuture, 0) as ApprovedFuture,
	isnull(@averageHours, 0) as AverageHours,
	@accrueLeave as AccrueLeave,
	@reasonRequired as ReasonRequired,
	@allowDocuments as AllowDocuments,
	@maximumLeave as MaximumLeave
	-- the 'booked hours' part comes from the calender projection
	-- projection =
	-- ((TotalHoursAccrued + TotalAccruedProjectionHours) - (TotalBookedHours + TotalHoursWorked)) / AverageHoursPerDay
	
END
