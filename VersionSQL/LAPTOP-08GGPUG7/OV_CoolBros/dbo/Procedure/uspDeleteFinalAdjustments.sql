/****** Object:  Procedure [dbo].[uspDeleteFinalAdjustments]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteFinalAdjustments](@headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM TimesheetRateAdjustmentItem WHERE TimesheetRateAdjustmentID IN (SELECT id FROM TimesheetRateAdjustment WHERE IsFinalisedHours = 1 AND TimesheetHeaderID = @headerId)
    DELETE FROM TimesheetRateAdjustment WHERE IsFinalisedHours = 1 AND TimesheetHeaderID = @headerId
END

