/****** Object:  Procedure [dbo].[uspCheckDeletePayrollCycleGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckDeletePayrollCycleGroup] 
	-- Add the parameters for the stored procedure here
	@value int, 
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @count int;
    -- Insert statements for procedure here
	set @count= (select count(p.id)
	from PayrollCycle p
	where p.PayrollCycleGroupID=@value)
	if (@count>0) begin
		set @ReturnValue=0;
	end
	else begin
		set @ReturnValue =1;
	end
END

