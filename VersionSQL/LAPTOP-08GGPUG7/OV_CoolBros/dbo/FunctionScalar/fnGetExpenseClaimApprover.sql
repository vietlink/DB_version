/****** Object:  Function [dbo].[fnGetExpenseClaimApprover]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetExpenseClaimApprover] 
(
	-- Add the parameters for the function here
	@epID int
)
RETURNS varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(max)
	DECLARE @approver1 int = (SELECT TOP 1 Approver1 FROM ExpenseClaimSettings)
	DECLARE @approver1PosID int= (SELECT TOP 1 Approver1PositionID FROM ExpenseClaimSettings)
	-- Add the T-SQL statements to compute the return value here
	IF (@approver1=1) BEGIN
		SET @Result = dbo.fnGetEmployeeManagerName(@epID)
	END ELSE BEGIN
		SET @Result = dbo.fnGetEmployeeNameByPositionID(@approver1PosID)
	END	

	-- Return the result of the function
	RETURN @Result

END

