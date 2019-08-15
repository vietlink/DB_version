/****** Object:  Procedure [dbo].[uspGetRegionByName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRegionByName] 
	-- Add the parameters for the stored procedure here
	@filter varchar(300), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
		SELECT * from HolidayRegion where Description=@filter and IsDeleted= @status
	
END

