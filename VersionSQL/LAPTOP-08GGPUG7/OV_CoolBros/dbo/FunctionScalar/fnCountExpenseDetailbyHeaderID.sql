/****** Object:  Function [dbo].[fnCountExpenseDetailbyHeaderID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnCountExpenseDetailbyHeaderID] 
(
	-- Add the parameters for the function here
	@headerID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COUNT(*)
	FROM ExpenseClaimDetail ecd
	WHERE ecd.ExpenseClaimHeaderID=@headerID

	-- Return the result of the function
	RETURN @Result

END

