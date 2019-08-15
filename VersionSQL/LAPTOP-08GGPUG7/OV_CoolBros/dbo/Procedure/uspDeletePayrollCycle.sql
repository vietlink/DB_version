/****** Object:  Procedure [dbo].[uspDeletePayrollCycle]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspDeletePayrollCycle] 
	-- Add the parameters for the stored procedure here
	@id int, @status bit
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
	if (@status=0) begin
		update PayrollCycle
		set IsDeleted=1
		where id = @id
	end
	else begin
		update PayrollCycle
		set IsDeleted=0
		where id = @id
	end		
END

