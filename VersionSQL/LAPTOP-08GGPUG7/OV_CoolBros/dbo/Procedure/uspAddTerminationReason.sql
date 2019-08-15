/****** Object:  Procedure [dbo].[uspAddTerminationReason]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddTerminationReason] 
	-- Add the parameters for the stored procedure here
	@name varchar(80), @group varchar(50), @status bit, @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@status=0) begin
		update TerminationReasons
		set 
		Grouping=@group,
		IsDeleted=@status
		where Value=@name
		set @ReturnValue=1;
	end
	else begin
		insert into TerminationReasons(Value, Grouping, IsDeleted)
		values
		(@name, 
		@group,
		0
		)
		set @ReturnValue= @@IDENTITY
	end
	
END

