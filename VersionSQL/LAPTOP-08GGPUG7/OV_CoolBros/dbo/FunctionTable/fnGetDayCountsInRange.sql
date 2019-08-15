/****** Object:  Function [dbo].[fnGetDayCountsInRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetDayCountsInRange](@from datetime, @to datetime)
RETURNS TABLE 
AS
RETURN 
(
	select datediff(day, -7, @to)/7-datediff(day, -6, @from)/7 AS [DayCount], 'Monday' as [Day]
	union all
	select datediff(day, -6, @to)/7-datediff(day, -5, @from)/7 AS [DayCount], 'Tuesday' as [Day]
	union all
	select datediff(day, -5, @to)/7-datediff(day, -4, @from)/7 AS [DayCount], 'Wednesday' as [Day]
	union all
	select datediff(day, -4, @to)/7-datediff(day, -3, @from)/7 AS [DayCount], 'Thursday' as [Day]
	union all
	select datediff(day, -3, @to)/7-datediff(day, -2, @from)/7 AS [DayCount], 'Friday' as [Day]
	union all
	select datediff(day, -2, @to)/7-datediff(day, -1, @from)/7 AS [DayCount], 'Saturday' as [Day]
	union all
	select datediff(day, -1, @to)/7-datediff(day, 0, @from)/7 AS [DayCount], 'Sunday' as [Day]
)

