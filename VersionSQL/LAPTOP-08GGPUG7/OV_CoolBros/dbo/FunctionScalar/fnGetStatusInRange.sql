/****** Object:  Function [dbo].[fnGetStatusInRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetStatusInRange] 
(
	-- Add the parameters for the function here
	@id int, @startdate datetime, @endDate datetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	set @Result= (select esh.StatusID 
	from EmployeeStatusHistory esh 
	where esh.EmployeeID=@id
	and ((esh.StartDate <=@startdate and esh.EndDate>= @endDate) or (esh.StartDate<=@startdate and esh.EndDate is null)))

	-- Return the result of the function
	RETURN @Result

END

