/****** Object:  Procedure [dbo].[uspUpdateExpenseDetailStatusByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateExpenseDetailStatusByID] 
	-- Add the parameters for the stored procedure here
	@ID int, @statusID int, @date datetime, @userID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE ExpenseClaimDetail
	SET
		ExpenseStatusID = @statusID,
		LastEditedByUserID = @userID,
		LastEditedDate = @date
	WHERE ID= @ID
END

