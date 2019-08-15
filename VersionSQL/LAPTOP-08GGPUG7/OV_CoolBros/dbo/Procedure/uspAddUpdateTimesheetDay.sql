/****** Object:  Procedure [dbo].[uspAddUpdateTimesheetDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateTimesheetDay](@headerId int, @date datetime, @startTime varchar(10), @finishTime varchar(10), @breaks decimal(10,5), @hours decimal(10,5), @haschanged bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @existingId int = 0;
	SELECT @existingId = ID FROM TimesheetDay WHERE TimesheetHeaderID = @headerId AND [Date] = @date;
	IF @existingId > 0 BEGIN
		UPDATE
			TimesheetDay
		SET
			StartTime = @startTime,
			FinishTime = @finishTime,
			Breaks = @breaks,
			[Hours] = @hours,
			HasChanged = @haschanged
		WHERE
			ID = @existingId
	END ELSE BEGIN
		INSERT INTO TimesheetDay(TimesheetHeaderID, [Date], StartTime, FinishTime, Breaks, [Hours], HasChanged)
			VALUES(@headerId, @date, @startTime, @finishTime, @breaks, @hours, @haschanged);
	END
END

