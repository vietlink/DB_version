/****** Object:  Procedure [dbo].[uspDeleteTerminationReason]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteTerminationReason] 
	-- Add the parameters for the stored procedure here
	@value varchar(80), @status bit, @hardDelete bit 
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@hardDelete=0) begin
		if (@status=0) begin
			update TerminationReasons	
			set IsDeleted=1
			where Value= @value
		end
		else begin
			update TerminationReasons	
			set IsDeleted=0
			where Value= @value
		end
	end
	else begin
		delete from TerminationReasons where Value=@value
	end
END

