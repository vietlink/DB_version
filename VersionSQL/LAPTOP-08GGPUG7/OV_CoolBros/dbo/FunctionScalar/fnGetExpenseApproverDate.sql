/****** Object:  Function [dbo].[fnGetExpenseApproverDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetExpenseApproverDate] 
(
	-- Add the parameters for the function here
	@headerID int
)
RETURNS varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(max)

	-- Add the T-SQL statements to compute the return value here
	SET @Result= (SELECT TOP 1 (esh.Date) 
	FROM ExpenseStatusHistory esh 	
	inner JOIN ExpenseStatus es ON esh.ExpenseStatusID= es.ID AND es.Code='A'
	WHERE 
	esh.ExpenseHeaderID=@headerID
	ORDER BY esh.date desc)


	-- Return the result of the function
	RETURN @Result

END

