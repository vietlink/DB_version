/****** Object:  Procedure [dbo].[uspDeleteRegion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteRegion] 
	-- Add the parameters for the stored procedure here
	@id int, @status bit, @hardDelete bit
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@hardDelete=0) begin
		if (@status=0) begin
			update HolidayRegion
			set IsDeleted=1
			where id= @id
		end else begin
			update HolidayRegion
			set IsDeleted=0
			where ID=@id
		end		
	end
	else begin
		delete from HolidayRegion
		where id= @id
	end
END

