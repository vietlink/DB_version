/****** Object:  Procedure [dbo].[uspCountLoadingRate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Linh Ngo
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspCountLoadingRate] 
	-- Add the parameters for the stored procedure here
	@count int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @count= (SELECT COUNT(*) FROM LoadingRate WHERE IsDeleted=0)
	RETURN @count
END

