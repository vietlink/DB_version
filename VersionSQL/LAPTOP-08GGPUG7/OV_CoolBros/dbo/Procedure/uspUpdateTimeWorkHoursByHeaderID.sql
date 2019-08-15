/****** Object:  Procedure [dbo].[uspUpdateTimeWorkHoursByHeaderID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateTimeWorkHoursByHeaderID](@headerId int, @dayCode varchar(20), @enabled bit, @normalHours decimal(10,5),
 @extraHours decimal(10,5), @startTime varchar(10), @endTime varchar(10), @breakMinutes decimal(10,5), @overtimeAfter decimal(10,5), @week int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (SELECT ID FROM TimeWorkHours WHERE TimeWorkHoursHeaderID = @headerId AND DayCode = @dayCode AND [Week] = @week) BEGIN
		UPDATE
			TimeWorkHours
		SET
			[Enabled] = @enabled,
			NormalHours = @normalHours,
			ExtraHours = @extraHours,
			StartTime = @startTime,
			EndTime = @endTime,
			BreakMinutes = @breakMinutes,
			OvertimeStartsAfter = @overtimeAfter
		WHERE
			TimeWorkHoursHeaderID = @headerId AND DayCode = @dayCode AND [Week] = @week

	END ELSE BEGIN
		INSERT INTO TimeWorkHours(DayCode, [Enabled], NormalHours, ExtraHours, StartTime, EndTime, BreakMinutes, TimeWorkHoursHeaderID, [Week], OvertimeStartsAfter)
			VALUES(@dayCode, @enabled, @normalHours, @extraHours, @startTime, @endTime, @breakMinutes, @headerId, @week, @overtimeAfter)
	END


END

