/****** Object:  Procedure [dbo].[uspUpdateCostCentre]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateCostCentre] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@code varchar(10),
	@description varchar(100),
	@isPayroll bit, 
	@isExpense bit,
	@ReturnValue int output 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	

	update CostCentres
	set Code = @code,
	Description = @description,
	IsPayrollCostCentre = @isPayroll,
	IsExpenseCostCentre = @isExpense
	where ID=@id
-- update related table needed
	
	IF @@error != 0
	BEGIN
		SET @ReturnValue =0
	
	END
	
	ELSE
	BEGIN
	
		SET @ReturnValue =@id 
	END
END

