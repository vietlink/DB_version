/****** Object:  Procedure [dbo].[upsGetWorkHourByDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[upsGetWorkHourByDay] 
	-- Add the parameters for the stored procedure here
	@headerID int,
	@day varchar(10) , 
	@week int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ew.WorkHours
	from EmployeeWorkHours ew
	where ew.Week=@week and ew.DayCode=@day and ew.EmployeeWorkHoursHeaderID=@headerID
END

