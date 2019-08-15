/****** Object:  Procedure [dbo].[uspAddCostCentre]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddCostCentre] 
	-- Add the parameters for the stored procedure here
	@code varchar(10), @description varchar(100), @isPayroll bit, @isExpense bit, @status bit, @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@status=0) begin
		update CostCentres
		set 
		Code= @code,
		Description=@description,
		IsPayrollCostCentre= @isPayroll,
		IsExpenseCostCentre= @isExpense,
		IsDeleted=@status
		where Code= @code
		set @ReturnValue=1;
	end
	else begin
		insert into CostCentres(Code, Description, IsPayrollCostCentre, IsExpenseCostCentre)
		values
		(@code, 
		@description,
		@isPayroll,
		@isExpense
		)
		set @ReturnValue= @@IDENTITY
	end
	
END

