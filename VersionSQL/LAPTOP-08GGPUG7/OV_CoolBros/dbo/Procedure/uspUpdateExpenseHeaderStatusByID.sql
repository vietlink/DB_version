/****** Object:  Procedure [dbo].[uspUpdateExpenseHeaderStatusByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateExpenseHeaderStatusByID] 
	-- Add the parameters for the stored procedure here
	@ID int, @statusID int, @updatedDate datetime, @userID int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE ExpenseClaimHeader
	SET
		ExpenseClaimStatusID = @statusID,
		LastEditedDate = @updatedDate,
		LastEditedByUserID = @userID
	WHERE ID= @ID
END

