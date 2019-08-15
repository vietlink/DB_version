/****** Object:  Function [dbo].[fnGetAccrueHoursByLeaveType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetAccrueHoursByLeaveType](@leaveTypeID int)
RETURNS decimal(25,15)
AS
BEGIN
	DECLARE @result decimal(25,15);
	DECLARE @StandardWorkingDay decimal(25, 15) = dbo.fnGetSettingByCode('StandardWorkingDay');
	DECLARE @StandardWorkingHoursPerWeek decimal(25, 15) = dbo.fnGetSettingByCode('StandardWorkingHoursPerWeek');

	DECLARE @AnnualLeaveDaysPerYear decimal(25, 15);
	SELECT @AnnualLeaveDaysPerYear = ISNULL(LeavePerYear, 0.0) FROM LeaveType WHERE ID = @leaveTypeID AND AccrueLeave = 1

	IF @AnnualLeaveDaysPerYear > 0 BEGIN
		DECLARE @WeekAccrueRate decimal(25, 15) = (@AnnualLeaveDaysPerYear * @StandardWorkingDay) / 52.0
		DECLARE @HourAccrueRate decimal(25, 15) = @WeekAccrueRate / @StandardWorkingHoursPerWeek

		RETURN @HourAccrueRate;
	END

	RETURN 0.0;
END

