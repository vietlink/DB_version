/****** Object:  Function [dbo].[fnGetTimesheetSubmitteDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetTimesheetSubmitteDate] 
(
	-- Add the parameters for the function here
	@timesheetID int
)
RETURNS varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = (SELECT TOP 1 tsh.Date
	FROM TimesheetStatusHistory tsh INNER JOIN TimesheetStatus ts ON tsh.TimesheetStatusID = ts.ID 
	WHERE tsh.TimesheetHeaderID = @timesheetID 
	AND ts.Code='S'
	ORDER BY tsh.Date DESC)

	-- Return the result of the function
	RETURN Convert (varchar, @Result, 21)

END

