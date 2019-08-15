/****** Object:  Procedure [dbo].[uspIsDeletedTerminationReason]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspIsDeletedTerminationReason] 
	-- Add the parameters for the stored procedure here
	@value varchar(80) , 
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @ReturnValue= (select IsDeleted 
	from TerminationReasons
	where Value= @value)
END

