/****** Object:  Procedure [dbo].[uspGetPublicHolidayInRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPublicHolidayInRange] 
	-- Add the parameters for the stored procedure here
	@from datetime, 
	@to datetime 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT h.Date,
	h.Description,
	lt.BackgroundColour, e.id
	from Holiday h
	inner join HolidayRegion hr on h.HolidayRegionID= hr.ID
	inner join EmployeeWorkHoursHeader ewh on ewh.HolidayRegionID= hr.ID
	inner join Employee e on ewh.EmployeeID = e.id and dbo.fnGetWorkHourHeaderIDByDay(e.id, h.Date)=ewh.ID
	, LeaveType lt
	where h.Date>=@from and h.Date<=@to and lt.Code='P' and e.status!='Deleted'
	
END
