/****** Object:  Function [dbo].[fnGetWorkedAccruableHours]    Committed by VersionSQL https://www.versionsql.com ******/

-- factor in how much leave a person has taken in a day, and if it counts for accruable hours
-- for example some one may book off half a day on a non accruable type, still need to accrue for
-- the 4 hours they worked, or if the type does accrue then all 8 hours for exampe.

CREATE FUNCTION [dbo].[fnGetWorkedAccruableHours](@empId int, @date datetime, @leaveTypeId int)
RETURNS decimal(18,8)
AS
BEGIN
	DECLARE @hoursInDay decimal(18,2) = dbo.fnGetHoursInDay(@empId, @date);
	--DECLARE @nonAccruableLeaveHoursTaken decimal(18,2) = dbo.fnGetNonAccruableHoursFromLeaveDate(@empId, @date, @leaveTypeId);
	-- function wasn't working correctly, design around getting hour minus non accrue wasn't deep enough.
	
	RETURN ISNULL(@hoursInDay, 0.0)-- - ISNULL(@nonAccruableLeaveHoursTaken, 0.0);
END

