/****** Object:  Function [dbo].[fnGetRecentSubmittedDateByDetailID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetRecentSubmittedDateByDetailID] 
(
	-- Add the parameters for the function here
	@detailID int
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result Datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = (select top 1 esh.Date
		from ExpenseStatusHistory esh
		inner join ExpenseStatus es on esh.ExpenseStatusID= es.ID
		where es.Code='S'and ExpenseDetailID=@detailID
		order by date desc)

	-- Return the result of the function
	RETURN @Result

END

