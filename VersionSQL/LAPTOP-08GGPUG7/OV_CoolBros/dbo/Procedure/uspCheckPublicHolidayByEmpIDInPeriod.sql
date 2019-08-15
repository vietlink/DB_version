/****** Object:  Procedure [dbo].[uspCheckPublicHolidayByEmpIDInPeriod]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckPublicHolidayByEmpIDInPeriod] 
	-- Add the parameters for the stored procedure here
	@empID int, @date datetime, @iResult int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SET @iResult= isnull((SELECT isnull(h.id, 0)
	FROM Holiday h
	INNER JOIN HolidayRegion hr ON h.HolidayRegionID= hr.ID
	INNER JOIN EmployeeWorkHoursHeader ewh ON hr.ID= ewh.HolidayRegionID AND dbo.fnGetWorkHourHeaderIDByDay(@empID, @date) =ewh.ID
	WHERE h.Date= @date),0)
	
END

