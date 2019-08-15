/****** Object:  Procedure [dbo].[uspAddTimeShiftLoadingRate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddTimeShiftLoadingRate](@id int, @headerId int, @normalHours bit, @timefrom varchar(10), @timeto varchar(10),
	@mondayId int, @tuesdayId int, @wednesdayId int, @thursdayId int, @fridayId int, @saturdayId int, @sundayId int, @holidayID int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF @id > 0 BEGIN
		UPDATE
			TimeShiftLoadingRates
		SET
			NormalHours = @normalHours,
			TimeFrom = @timeFrom,
			TimeTo = @timeTo,
			MondayID = @mondayId,
			TuesdayID = @tuesdayId,
			WednesdayID = @wednesdayId,
			ThursdayID = @thursdayId,
			FridayID = @fridayId,
			SaturdayID = @saturdayId,
			SundayID = @sundayId,
			PublicHolidayID = @holidayID
		WHERE
			id = @id;
	END
	ELSE BEGIN
		INSERT INTO TimeShiftLoadingRates(NormalHours, TimeShiftLoadingHeaderID, TimeFrom, TimeTo,
		MondayID, TuesdayID, WednesdayID, ThursdayID, FridayID,	SaturdayID, SundayID, PublicHolidayID)
		VALUES(@normalHours, @headerId, @timeFrom, @timeTo, @mondayId, @tuesdayId, @WednesdayId, @thursdayId, @fridayId, @saturdayId, @sundayId, @holidayID)
	END
END

