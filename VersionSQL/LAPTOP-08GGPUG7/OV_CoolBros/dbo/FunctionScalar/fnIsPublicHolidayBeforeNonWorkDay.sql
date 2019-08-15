/****** Object:  Function [dbo].[fnIsPublicHolidayBeforeNonWorkDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnIsPublicHolidayBeforeNonWorkDay](@empId int, @date DateTime)
RETURNS bit
AS
BEGIN

	-- Find the last annual leave in a 2 week range
	DECLARE @lastPublicHoliday DateTime;
	SELECT 
		@lastPublicHoliday = MAX(h.Date)
	FROM 
		Holiday h
	INNER JOIN HolidayRegion hr ON h.HolidayRegionID= hr.ID
		INNER JOIN EmployeeWorkHoursHeader ewh ON hr.ID= ewh.HolidayRegionID AND dbo.fnGetWorkHourHeaderIDByDay(@empId, h.Date)=ewh.ID
	WHERE
	h.Date <= @date AND h.Date> DATEADD(day, -14, @date) 	
	-- No leave found so exit with false
	IF @lastPublicHoliday IS NULL
		RETURN 0;


	-- Create a fake date range between the last annual leave and check date
	DECLARE @dateTable TABLE ([date] DateTime);

	DECLARE @StartDate DateTime = DATEADD(day, 1, @lastPublicHoliday);
	DECLARE @EndDate DateTime = @date

	INSERT INTO @dateTable SELECT  DATEADD(DAY, nbr - 1, @StartDate)
	FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY c.object_id ) AS Nbr
				FROM      sys.columns c
			) nbrs
	WHERE   nbr - 1 <= DATEDIFF(DAY, @StartDate, @EndDate)
	
	-- Sum up hours between last annual leave and check date
	DECLARE @hoursInDay decimal(18, 8);
	SELECT
		@hoursInDay = ISNULL(SUM(dbo.fnGetHoursInDay(@empId, dt.[date])), 0.0)
	FROM
		@dateTable dt

	-- annual leave was found, no hours between now and sick leave, so return true
	IF @hoursInDay = 0
		RETURN 1;
	
	RETURN 0;

END

