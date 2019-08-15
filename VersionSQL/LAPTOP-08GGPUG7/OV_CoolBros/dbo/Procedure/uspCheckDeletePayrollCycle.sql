/****** Object:  Procedure [dbo].[uspCheckDeletePayrollCycle]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckDeletePayrollCycle] 
	-- Add the parameters for the stored procedure here
	@value int, 
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @isDelete int;
    -- Insert statements for procedure here
	set @isDelete= (select p.PayrollStatusID
	from PayrollCycle p
	where p.ID=@value)
	if (@isDelete>1) begin
		set @ReturnValue=0; --cannot delete
	end
	else begin
		set @ReturnValue =1; --can delete
	end
END

