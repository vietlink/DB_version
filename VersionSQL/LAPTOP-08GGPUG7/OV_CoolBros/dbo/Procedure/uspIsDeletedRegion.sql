/****** Object:  Procedure [dbo].[uspIsDeletedRegion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspIsDeletedRegion] 
	-- Add the parameters for the stored procedure here
	@value varchar(10) , 
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @ReturnValue= (select IsDeleted
	from HolidayRegion
	where Code= @value)
END
