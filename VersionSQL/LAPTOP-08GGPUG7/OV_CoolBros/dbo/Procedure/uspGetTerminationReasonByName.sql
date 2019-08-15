/****** Object:  Procedure [dbo].[uspGetTerminationReasonByName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTerminationReasonByName] 
	-- Add the parameters for the stored procedure here
	@filter varchar(300), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
		SELECT * from TerminationReasons where Value=@filter and IsDeleted= @status
	
END

