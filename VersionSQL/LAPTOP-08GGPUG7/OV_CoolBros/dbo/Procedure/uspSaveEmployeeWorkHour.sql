/****** Object:  Procedure [dbo].[uspSaveEmployeeWorkHour]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSaveEmployeeWorkHour](@empId int, @hours decimal(18,2), @startDateTime datetime, 
	@endDateTime datetime, @enabled bit, @dayCode varchar(20), @headerId int, @week int,
	@dayCodeShort varchar(20), @extraHours decimal(10,5), @startTime varchar(8), @endTime varchar(8), @breakMinutes decimal(10,5), @overtimeAfter decimal(10,5)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM EmployeeWorkHours WHERE EmployeeID = @empId AND DayCode = @dayCode AND EmployeeWorkHoursHeaderID = @headerId AND [Week] = @week) BEGIN
		UPDATE
			EmployeeWorkHours
		SET
			WorkHours = @hours,
			StartDateTime = @startDateTime,
			EndDateTime = @endDateTime,
			[Enabled] = @enabled,
			ExtraHours = @extraHours,
			StartTime = @startTime,
			EndTime = @endTime,
			BreakMinutes = @breakMinutes,
			OvertimeStartsAfter = @overtimeAfter
		WHERE
			EmployeeID = @empId AND DayCode = @dayCode AND EmployeeWorkHoursHeaderID = @headerId AND [week] = @week
	END ELSE BEGIN
		INSERT INTO EmployeeWorkHours(EmployeeID, WorkHours, StartDateTime, EndDateTime, [Enabled], DayCode, EmployeeWorkHoursHeaderID, [week],
		DayCodeShort, ExtraHours, StartTime, EndTime, BreakMinutes, OvertimeStartsAfter)
			VALUES (@empId, @hours, @startDateTime, @endDateTime, @enabled, @dayCode, @headerId, @week,
			@dayCodeShort, @extraHours, @startTime, @endTime, @breakMinutes, @overtimeAfter);
	END
END
