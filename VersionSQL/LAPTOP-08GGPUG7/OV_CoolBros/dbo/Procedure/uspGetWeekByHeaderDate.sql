/****** Object:  Procedure [dbo].[uspGetWeekByHeaderDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWeekByHeaderDate] 
	-- Add the parameters for the stored procedure here
	@header int , 
	@date datetime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @result int;
	set @result= dbo.fnGetWeekByHeaderDate(@header, @date)
	return @result
END

