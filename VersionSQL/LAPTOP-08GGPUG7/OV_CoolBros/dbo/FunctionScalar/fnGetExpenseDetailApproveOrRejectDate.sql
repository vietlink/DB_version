/****** Object:  Function [dbo].[fnGetExpenseDetailApproveOrRejectDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetExpenseDetailApproveOrRejectDate] 
(
	-- Add the parameters for the function here
	@detailID int
)
RETURNS Datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result Datetime

	-- Add the T-SQL statements to compute the return value here
	SET @Result = (
	SELECT TOP 1 esh.Date
	FROM ExpenseStatusHistory esh
	INNER JOIN ExpenseClaimDetail ecd ON ecd.id= esh.ExpenseDetailID
	INNER JOIN ExpenseStatus es ON esh.ExpenseStatusID = es.ID
	WHERE (es.Code='A' OR es.Code='R')
	AND ecd.id= @detailID
	ORDER BY esh.Date DESC
	)

	-- Return the result of the function
	RETURN @Result

END

