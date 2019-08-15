/****** Object:  Function [dbo].[fnGetExpenseLastSubmitterID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetExpenseLastSubmitterID] 
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
	SET @Result= (SELECT TOP 1 (esh.SubmittedByID) 
	FROM ExpenseStatusHistory esh 	
	inner JOIN ExpenseStatus es ON esh.ExpenseStatusID= es.ID AND es.Code='S'
	WHERE 
	esh.ExpenseHeaderID=@headerID
	ORDER BY esh.date desc)


	-- Return the result of the function
	RETURN @Result

END

