/****** Object:  Function [dbo].[fnGetExpenseItemStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetExpenseItemStatus] 
(
	-- Add the parameters for the function here
	@id int
)
RETURNS varchar(20)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(20)
	DECLARE @payCycleID int = (SELECT isnull(ecd.PayCycleID,0) FROM ExpenseClaimDetail ecd INNER JOIN ExpenseClaimHeader ech ON ecd.ExpenseClaimHeaderID = ech.ID WHERE ecd.ID=@id)
	IF (@payCycleID!=0) BEGIN
		SET @Result= 'Approved (Paid)';
	END ELSE BEGIN
	-- Add the T-SQL statements to compute the return value here
		SELECT @Result = (SELECT es.Description
		FROM ExpenseClaimDetail ecd 		
		INNER JOIN ExpenseStatus es ON ecd.ExpenseStatusID= es.id
		WHERE ecd.ID=@id)
	END
	IF @Result='Approved' BEGIN SET @Result= 'Approved (Not Paid)' END
	-- Return the result of the function
	RETURN @Result

END

