/****** Object:  Procedure [dbo].[uspAddOrUpdateExpenseClaimHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddOrUpdateExpenseClaimHeader] 
	-- Add the parameters for the stored procedure here
	@id int, @claimDate datetime, @description varchar(250), @claimStatus int, @isLocked bit, @createdByUserID int, @createdDate datetime, @lastEditByUserID int, @lastEditDate datetime, @createdForUserID int, @isPartiallyApproved bit, @comment varchar(200), @type int, @ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@id=0) BEGIN
		INSERT INTO ExpenseClaimHeader(ExpenseClaimDate, Description, ExpenseClaimStatusID, isLocked, CreatedByUserID, CreatedDate, LastEditedByUserID, LastEditedDate, CreatedForUserID, isPartiallyApproved, Comment, ClaimType)
		VALUES (@claimDate, @description, @claimStatus, @isLocked, @createdByUserID, @createdDate, @lastEditByUserID, @lastEditDate, @createdForUserID, @isPartiallyApproved, @comment, @type)
		SET @ReturnValue= @@IDENTITY
	END
	ELSE BEGIN
		UPDATE ExpenseClaimHeader
		SET 
			ExpenseClaimDate= @claimDate,
			Description= @description,
			ExpenseClaimStatusID= @claimStatus,
			isLocked = @isLocked,
			LastEditedByUserID= @lastEditByUserID,
			LastEditedDate= @lastEditDate,
			isPartiallyApproved = @isPartiallyApproved,
			Comment= @comment,
			ClaimType= @type
		WHERE ID= @id
		SET @ReturnValue= @id
	END
END

