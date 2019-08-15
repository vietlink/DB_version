/****** Object:  Function [dbo].[fnIsNWDInRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnIsNWDInRange] 
(
	-- Add the parameters for the function here
	@empID int, @fromDate datetime, @toDate datetime
)
RETURNS int
AS
BEGIN
	DECLARE @nextPublicHoliday DateTime;
	SELECT 
		@nextPublicHoliday = MIN(h.Date)
	FROM 
		Holiday h
		INNER JOIN HolidayRegion hr ON h.HolidayRegionID= hr.ID
		INNER JOIN EmployeeWorkHoursHeader ewh ON hr.ID= ewh.HolidayRegionID AND dbo.fnGetWorkHourHeaderIDByDay(@empId, h.Date)=ewh.ID	
	WHERE
		h.Date>= @fromDate AND h.Date <=@toDate

	DECLARE @nextNWD DateTime;
	DECLARE @isFound bit=0;
	DECLARE @temp datetime= @fromDate;
	WHILE (@temp<=@toDate AND @isFound=0) BEGIN
		DECLARE @workHour decimal= dbo.fnGetHoursInDay(@empID, @temp);
		IF (@workHour IS NULL) BEGIN
			SET @nextNWD=@temp;
			SET @isFound=1;
		END
		SET @temp = DATEADD(day, 1, @temp)
	END
	DECLARE @nextAnnualLeave Datetime
	SELECT @nextAnnualLeave = MIN(lrd.LeaveDateFrom)
	FROM LeaveRequest lr INNER JOIN LeaveRequestDetail lrd ON lr.ID= lrd.LeaveRequestID
	INNER JOIN LeaveType lt ON lr.LeaveTypeID= lt.ID
	WHERE (lt.SystemCode='A' OR lt.SystemCode = 'AL')
	AND lr.IsCancelled=0
	AND lrd.LeaveDateFrom>=@fromDate AND lrd.LeaveDateFrom<=@toDate
	AND lr.EmployeeID=@empID
	IF @nextNWD IS NULL 
		RETURN 0;
	IF (@nextPublicHoliday IS NULL AND @nextAnnualLeave IS NULL) 					
			RETURN 1;
	ELSE IF (@nextPublicHoliday IS NULL AND @nextAnnualLeave IS NOT NULL) BEGIN
		IF (@nextNWD< @nextAnnualLeave) RETURN 1; ELSE RETURN 0;
	END ELSE IF (@nextAnnualLeave IS NULL AND @nextPublicHoliday IS NOT NULL) BEGIN
		IF (@nextNWD< @nextPublicHoliday) RETURN 1; ELSE RETURN 0;
	END ELSE BEGIN
		IF (@nextNWD<@nextPublicHoliday AND @nextNWD<@nextAnnualLeave) RETURN 1;
		ELSE RETURN 0;	
	END	
	RETURN 0;	

END

