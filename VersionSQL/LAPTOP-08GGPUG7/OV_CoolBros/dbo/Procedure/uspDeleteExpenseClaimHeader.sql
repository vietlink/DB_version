/****** Object:  Procedure [dbo].[uspDeleteExpenseClaimHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspDeleteExpenseClaimHeader] 
	-- Add the parameters for the stored procedure here
	@id int, @ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM ExpenseStatusHistory WHERE ExpenseHeaderID = @id
	DELETE FROM ExpenseClaimHeader WHERE ID = @id
	SET @ReturnValue = @@ROWCOUNT
END

