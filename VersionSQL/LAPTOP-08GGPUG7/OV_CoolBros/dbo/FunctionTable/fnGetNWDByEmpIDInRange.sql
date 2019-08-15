/****** Object:  Function [dbo].[fnGetNWDByEmpIDInRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetNWDByEmpIDInRange] 
(
	-- Add the parameters for the function here
	@empID int, @fromDate datetime, @toDate datetime
)
RETURNS 
@result TABLE 
(
	-- Add the column definitions for the TABLE variable here
	empID int, 
	_date datetime
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	WHILE (@fromDate <= @toDate) BEGIN
		DECLARE @hour decimal = isnull (dbo.fnGetHoursInDay(@empID, @fromDate),0)
		IF (@hour = 0) BEGIN
			INSERT INTO @result VALUES (@empID, @fromDate)
		END
		SET @fromDate = DATEADD(day, 1, @fromDate);
	END
	
	RETURN 
END

