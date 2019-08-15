/****** Object:  Function [dbo].[fnGetTotalWorkHour]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetTotalWorkHour] 
(
	-- Add the parameters for the function here
	@empID int, @from datetime, @to datetime
)
RETURNS decimal
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal;
	declare @i datetime;
	-- Add the T-SQL statements to compute the return value here
	set @i=@from;
	set @Result=0;
	while (@i<=@to)
	begin
		declare @workhour decimal= dbo.fnGetHoursInDay(@empID, @i);
		set @Result= @Result+ isnull(@workhour,0.0);
		set @i= DATEADD(day, 1, @i);
	end

	-- Return the result of the function
	RETURN @Result

END

