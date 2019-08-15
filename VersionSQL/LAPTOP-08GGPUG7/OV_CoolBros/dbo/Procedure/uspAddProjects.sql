/****** Object:  Procedure [dbo].[uspAddProjects]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddProjects] 
	-- Add the parameters for the stored procedure here
	@code varchar(10), @description varchar(max), @clientID int, @PayCostCenterID int, @ExpenseCostCentreID int, @active bit, @status bit, @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@status=0) begin
		update Projects
		set 
		Code= @code,
		Description=@description,
		ClientID= @clientID,
		PayCostCentreID= @PayCostCenterID,
		ExpenseCostCentreID= @ExpenseCostCentreID,
		IsActive= @active,
		IsDeleted=@status
		where Code= @code
		set @ReturnValue=1;
	end
	else begin
		insert into Projects(Code, Description, ClientID, PayCostCentreID, ExpenseCostCentreID, IsActive)
		values
		(@code, 
		@description,
		@clientID,
		@PayCostCenterID,
		@ExpenseCostCentreID,
		@active
		)
		set @ReturnValue= @@IDENTITY
	end
	
END

