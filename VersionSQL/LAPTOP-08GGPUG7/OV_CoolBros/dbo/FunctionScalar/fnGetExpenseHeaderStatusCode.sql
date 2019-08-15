/****** Object:  Function [dbo].[fnGetExpenseHeaderStatusCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create FUNCTION [dbo].[fnGetExpenseHeaderStatusCode] 
(
	-- Add the parameters for the function here
	@id int
)
RETURNS varchar(10)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(10)
	DECLARE @payCycleID int = (SELECT isnull(ech.PayCycleID,0) FROM ExpenseClaimHeader ech WHERE ech.ID=@id)
	IF (@payCycleID!=0) BEGIN
		SET @Result= 'Pd';
	END ELSE BEGIN
	-- Add the T-SQL statements to compute the return value here
		SELECT @Result = (SELECT es.Code
		FROM ExpenseClaimHeader ech 		
		INNER JOIN ExpenseStatus es ON ech.ExpenseClaimStatusID= es.id
		WHERE ech.ID=@id)
	END
	-- Return the result of the function
	RETURN @Result

END

