/****** Object:  Procedure [dbo].[uspGetTimesheetAdjustmentItems]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimesheetAdjustmentItems](@adjustmentId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT i.*, r.Value as rate FROM TimesheetRateAdjustmentItem i INNER JOIN LoadingRate r ON r.ID = i.RateID WHERE i.TimesheetRateAdjustmentID = @adjustmentId
END

