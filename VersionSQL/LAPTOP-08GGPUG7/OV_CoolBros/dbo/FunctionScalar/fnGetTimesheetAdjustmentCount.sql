/****** Object:  Function [dbo].[fnGetTimesheetAdjustmentCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetTimesheetAdjustmentCount](@headerId int)
RETURNS int
AS
BEGIN
	DECLARE @count int = 0;

	DECLARE @normalRate decimal(10,5) = 0;
	DECLARE @toilRate decimal(10, 5) = 0;
	DECLARE @rateSum decimal(10,5) = 0;
	DECLARE @finalRateSum decimal(10, 5) = 0;

    SELECT @normalRate = SUM(NormalRate), @toilRate = SUM(toilRate) FROM TimesheetRateAdjustment WHERE IsFinalisedHours = 0 AND TimesheetHeaderID = @headerId;
	SELECT @rateSum = SUM(Balance) FROM TimesheetRateAdjustmentItem WHERE TimesheetRateAdjustmentID IN (SELECT ID FROM TimesheetRateAdjustment WHERE IsFinalisedHours = 0 AND TimesheetHeaderID = @headerId)

	SELECT @finalRateSum = SUM(Balance) FROM TimesheetRateAdjustmentItem WHERE TimesheetRateAdjustmentID IN (SELECT ID FROM TimesheetRateAdjustment WHERE IsFinalisedHours = 1 AND TimesheetHeaderID = @headerId)

	IF @normalRate > 0 OR @toilRate > 0 OR @rateSum > 0 OR @finalRateSum > 0
		RETURN 1;


	RETURN 0;
END

