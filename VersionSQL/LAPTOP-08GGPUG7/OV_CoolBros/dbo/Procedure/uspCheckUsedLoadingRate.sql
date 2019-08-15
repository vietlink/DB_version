/****** Object:  Procedure [dbo].[uspCheckUsedLoadingRate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckUsedLoadingRate] 
	-- Add the parameters for the stored procedure here
	@rateID int, @ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @ReturnValue= COUNT(*)
	FROM TimesheetRateAdjustmentItem
	WHERE RateID= @rateID
	RETURN @ReturnValue
END

