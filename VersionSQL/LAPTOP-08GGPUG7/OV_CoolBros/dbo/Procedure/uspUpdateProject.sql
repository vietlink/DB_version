/****** Object:  Procedure [dbo].[uspUpdateProject]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateProject] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@code varchar(10),
	@description varchar(max),
	@clientID int,
	@PayCostCenterID int,
	@ExpenseCostCentreID int,
	@active bit,
	@ReturnValue int output 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	

	update Projects
	set Code= @code,
	Description=@description,
	ClientID= @clientID,
	PayCostCentreID= @PayCostCenterID,
	ExpenseCostCentreID= @ExpenseCostCentreID,
	IsActive= @active
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

