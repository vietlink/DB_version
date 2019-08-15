/****** Object:  Procedure [dbo].[uspDeletePayrollCyclePeriod]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspDeletePayrollCyclePeriod] 
	-- Add the parameters for the stored procedure here
	@id int, @status bit, @hardDelete bit
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
	IF (@hardDelete=0) BEGIN
		if (@status=0) begin
			update PayrollCyclePeriods
			set IsDeleted=1
			where ID= @id
		end
		else begin
			update PayrollCyclePeriods
			set IsDeleted=0
			where ID= @id
		end	
	END ELSE BEGIN
		DELETE FROM PayrollCyclePeriods WHERE ID = @id
	END
END

