/****** Object:  Procedure [dbo].[uspDeleteExpenseDetailHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspDeleteExpenseDetailHistory] 
	-- Add the parameters for the stored procedure here
	@detailID int  
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM ExpenseStatusHistory
	WHERE ExpenseDetailID = @detailID
END

