/****** Object:  Procedure [dbo].[uspDeleteShiftLoadingHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteShiftLoadingHeader] 
	-- Add the parameters for the stored procedure here
	@id int, @status bit, @hardDelete bit
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--DECLARE @hardDelete INT;
	--DECLARE @empWorkHourHeader INT= (SELECT COUNT(*) FROM EmployeeWorkHoursHeader WHERE TimeShiftLoadingHeaderID= @id);
	--DECLARE @workProfile INT = (SELECT COUNT(*) FROM TimeWorkProfileTemplate WHERE TimeShiftLoadingHeaderID = @id);
	--SET @hardDelete= @empWorkHourHeader + @workProfile;
	if (@hardDelete=0) begin
		if (@status=0) begin
			update TimeShiftLoadingHeader
			set IsDeleted=1
			where ID= @id
		end
		else begin
			update TimeShiftLoadingHeader
			set IsDeleted=0
			where ID= @id
		end
	end
	else begin
		delete from TimeShiftLoadingHeader where ID=@id
		DELETE FROM TimeShiftLoadingRates WHERE TimeShiftLoadingHeaderID = @id
	end
	
END

