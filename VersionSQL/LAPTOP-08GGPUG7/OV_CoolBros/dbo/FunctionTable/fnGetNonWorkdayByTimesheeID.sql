/****** Object:  Function [dbo].[fnGetNonWorkdayByTimesheeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetNonWorkdayByTimesheeID] 
(
	-- Add the parameters for the function here
	@timesheetID int
	 
)
RETURNS 
@result TABLE 
(
	-- Add the column definitions for the TABLE variable here
	_date datetime 
	 
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	DECLARE @paycycleID int = (SELECT th.PayrollCycleID FROM TimesheetHeader th WHERE th.ID= @timesheetID)
	DECLARE @fromDate datetime= (SELECT p.FromDate FROM PayrollCycle p WHERE p.ID= @paycycleID)
	DECLARE @toDate datetime= (SELECT p.ToDate FROM PayrollCycle p WHERE p.ID= @paycycleID)
	DECLARE @temp table(_tempDate datetime)
	WHILE (@fromDate<=@toDate) BEGIN
		INSERT INTO @temp VALUES(@fromDate);
		SET @fromDate= DATEADD(day, 1, @fromDate);
	END	
	INSERT INTO @result 
	SELECT t._tempDate 
	FROM @temp t 
	WHERE t._tempDate  NOT IN (SELECT d.Date FROM TimesheetDay d WHERE d.TimesheetHeaderID=@timesheetID)
	
	RETURN 
END

