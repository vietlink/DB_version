/****** Object:  Function [dbo].[fnGetExpenseHeaderStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetExpenseHeaderStatus] 
(
	-- Add the parameters for the function here
	@id int
)
RETURNS varchar(20)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(20)
	DECLARE @payCycleID int = (SELECT isnull(ech.PayCycleID,0) FROM ExpenseClaimHeader ech WHERE ech.ID=@id)
	IF (@payCycleID!=0) BEGIN
		SET @Result= 'Approve (Paid)';
	END ELSE BEGIN
	-- Add the T-SQL statements to compute the return value here
		SELECT @Result = (SELECT es.Description
		FROM ExpenseClaimHeader ech 		
		INNER JOIN ExpenseStatus es ON ech.ExpenseClaimStatusID= es.id
		WHERE ech.ID=@id)
	END
	-- Return the result of the function
	IF (@Result='Approved') BEGIN SET @Result='Approve (Not Paid)' END
	RETURN @Result

END

