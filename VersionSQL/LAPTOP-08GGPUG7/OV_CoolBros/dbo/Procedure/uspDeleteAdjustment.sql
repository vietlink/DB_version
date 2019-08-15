/****** Object:  Procedure [dbo].[uspDeleteAdjustment]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteAdjustment](@adjustmentId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM TimesheetRateAdjustmentItem WHERE TimesheetRateAdjustmentID = @adjustmentId;
	DELETE FROM TimesheetRateAdjustment WHERE id = @adjustmentId;
END

