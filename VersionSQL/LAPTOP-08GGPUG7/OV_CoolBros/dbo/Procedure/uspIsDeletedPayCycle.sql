/****** Object:  Procedure [dbo].[uspIsDeletedPayCycle]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspIsDeletedPayCycle] 
	-- Add the parameters for the stored procedure here
	@description varchar(max) , 
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @ReturnValue= (select isnull(IsDeleted,0) 
	from PayrollCycle
	where Description=@description)
	IF @ReturnValue is null BEGIN
		SET @ReturnValue=0
	END
END

