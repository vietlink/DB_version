/****** Object:  Procedure [dbo].[uspGetTimeShiftLoadingRatesByHeaderID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimeShiftLoadingRatesByHeaderID](@headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		tslr.*, 
		rM.value as Monday,
		rTu.value as Tuesday,
		rW.value as Wednesday,
		rTh.value as Thursday,
		rF.value as Friday,
		rSa.value as Saturday,
		rSu.value as Sunday,
		rH.value as Holiday		
	FROM TimeShiftLoadingRates 
		tslr
	LEFT OUTER JOIN LoadingRate rM
	ON
	rM.ID = tslr.MondayID

	LEFT OUTER JOIN LoadingRate rTu
	ON
	rTu.ID = tslr.TuesdayID

	LEFT OUTER JOIN LoadingRate rW
	ON
	rW.ID = tslr.WednesdayID

	LEFT OUTER JOIN LoadingRate rTh
	ON
	rTh.ID = tslr.ThursdayID

	LEFT OUTER JOIN LoadingRate rF
	ON
	rF.ID = tslr.FridayID

	LEFT OUTER JOIN LoadingRate rSa
	ON
	rSa.ID = tslr.SaturdayID

	LEFT OUTER JOIN LoadingRate rSu
	ON
	rSu.ID = tslr.SundayID

	LEFT OUTER JOIN LoadingRate rH
	ON
	rH.ID = tslr.PublicHolidayID
	
	WHERE tslr.TimeShiftLoadingHeaderID = @headerId
    ORDER BY CONVERT(DATETIME, tslr.TimeFrom, 108);
END

