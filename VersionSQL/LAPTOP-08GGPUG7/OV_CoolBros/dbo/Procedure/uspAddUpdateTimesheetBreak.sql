/****** Object:  Procedure [dbo].[uspAddUpdateTimesheetBreak]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateTimesheetBreak](@id int, @headerId int, @startTime varchar(10), @endTime varchar(10), @minutes decimal(10,5), @date datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @id > 0 BEGIN
		UPDATE
			TimesheetBreaks
		SET
			StartTime = @startTime,
			EndTime = @endTime,
			[Minutes] = @minutes
		WHERE
			id = @id;
	END
	ELSE BEGIN
		INSERT INTO
			TimesheetBreaks(TimesheetHeaderID, StartTime, EndTime, [Minutes], [Date])
				VALUES(@headerId, @startTime, @endTime, @minutes, @date);
	END
END

