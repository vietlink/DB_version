/****** Object:  Procedure [dbo].[uspCheckDeleteRegion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckDeleteRegion] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@ReturnValue int output --0 cannot delete, 1 can be deleted
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @count int;
	declare @count1 int;
	declare @count2 int;
    -- Insert statements for procedure here
	set @count= (select count(n.id)
	from Holiday n
	where n.HolidayRegionID = @id)
	SET @count1= (SELECT COUNT(e.id) FROM Employee e
	WHERE e.HolidayRegionID = @id)
	SET @count2= (SELECT COUNT(ewh.id) FROM EmployeeWorkHoursHeader ewh
	WHERE ewh.HolidayRegionID = @id)
	if (@count > 0 OR @count1 > 0 OR @count2 > 0) begin
		set @ReturnValue = 0;
	end
	else begin
		set @ReturnValue = 1;
	end
END
