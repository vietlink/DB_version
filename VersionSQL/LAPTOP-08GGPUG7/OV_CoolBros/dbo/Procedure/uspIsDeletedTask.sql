/****** Object:  Procedure [dbo].[uspIsDeletedTask]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspIsDeletedTask] 
	-- Add the parameters for the stored procedure here
	@code varchar(10) , 
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @ReturnValue= (select IsDeleted 
	from Tasks
	where Code=@code)
END

