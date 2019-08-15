/****** Object:  Procedure [dbo].[uspGetTimesheetAdjustmentCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimesheetAdjustmentCount](@headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT COUNT(*) as [Count] FROM TimeSheetAdjustments WHERE HeaderID = @headerId;
END

