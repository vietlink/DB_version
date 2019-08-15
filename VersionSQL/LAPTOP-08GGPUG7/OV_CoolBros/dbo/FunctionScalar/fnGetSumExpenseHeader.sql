/****** Object:  Function [dbo].[fnGetSumExpenseHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetSumExpenseHeader] 
(
	-- Add the parameters for the function here
	@headerID int
)
RETURNS decimal(10,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(10,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = (
		SELECT isnull (SUM(ecd.ExpenseAmount),0)
		FROM ExpenseClaimHeader ech
		INNER JOIN ExpenseClaimDetail ecd ON ech.id= ecd.ExpenseClaimHeaderID
		INNER JOIN ExpenseStatus es ON ecd.ExpenseStatusID = es.ID
		WHERE es.Code!='R'
		AND ech.id= @headerID)

	-- Return the result of the function
	RETURN @Result

END

