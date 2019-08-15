/****** Object:  Procedure [dbo].[uspDeleteExpenseHeaderHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspDeleteExpenseHeaderHistory] 
	-- Add the parameters for the stored procedure here
	@headerID int  
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM ExpenseStatusHistory
	WHERE ExpenseHeaderID = @headerID
END

