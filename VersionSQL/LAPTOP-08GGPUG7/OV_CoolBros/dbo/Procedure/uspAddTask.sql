/****** Object:  Procedure [dbo].[uspAddTask]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspAddTask] 
	-- Add the parameters for the stored procedure here
	@code varchar(10), @description varchar(100), @status bit, @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@status=0) begin
		update Tasks
		set 
		Code= @code,
		Description=@description,
		IsDeleted=@status
		where Code= @code
		set @ReturnValue=1;
	end
	else begin
		insert into Tasks(Code, Description)
		values
		(@code, 
		@description		
		)
		set @ReturnValue= @@IDENTITY
	end
	
END

