/****** Object:  Procedure [dbo].[uspDeleteExpenseClaimDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteExpenseClaimDetail] 
	-- Add the parameters for the stored procedure here
	@id int, @ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM ExpenseStatusHistory WHERE ExpenseDetailID = @id
	DELETE FROM ExpenseClaimDetail WHERE ID = @id
	SET @ReturnValue = @@ROWCOUNT
END

