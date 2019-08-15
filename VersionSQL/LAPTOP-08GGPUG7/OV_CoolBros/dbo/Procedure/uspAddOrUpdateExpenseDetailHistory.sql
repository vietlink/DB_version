/****** Object:  Procedure [dbo].[uspAddOrUpdateExpenseDetailHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddOrUpdateExpenseDetailHistory] 
	-- Add the parameters for the stored procedure here
	@id int, @detailID int, @statusID int, @date datetime, @submittedByUserID int, @approvedByUserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@id=0) BEGIN
		INSERT INTO ExpenseStatusHistory (ExpenseDetailID, ExpenseStatusID, Date, SubmittedByID, ApprovedByID)
		VALUES (@detailID, @statusID, @date, @submittedByUserID, @approvedByUserID)
	END
	ELSE BEGIN
		UPDATE ExpenseStatusHistory
		SET
			ExpenseStatusID = @statusID,
			Date = @date,
			SubmittedByID = @submittedByUserID,
			ApprovedByID= @approvedByUserID
		WHERE ID= @id
	END
END

