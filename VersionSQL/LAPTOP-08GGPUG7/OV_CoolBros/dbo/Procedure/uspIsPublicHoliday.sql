/****** Object:  Procedure [dbo].[uspIsPublicHoliday]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspIsPublicHoliday](@date datetime, @regionId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS(SELECT id FROM Holiday WHERE [date] = @date AND HolidayRegionID = @regionId) BEGIN
		SELECT 1 as result;
		return;
	END
	SELECT 0 as result;
    
END

