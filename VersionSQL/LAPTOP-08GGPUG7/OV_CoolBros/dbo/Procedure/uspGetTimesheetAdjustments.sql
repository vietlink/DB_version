/****** Object:  Procedure [dbo].[uspGetTimesheetAdjustments]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimesheetAdjustments](@timesheetId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM TimesheetRateAdjustment WHERE TimesheetHeaderId = @timesheetId AND IsFinalisedHours = 0
END

