/****** Object:  Procedure [dbo].[uspDeleteLoadingRate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteLoadingRate] 
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
			update LoadingRate
			set IsDeleted=1
			where ID= @id
		end else begin
			update LoadingRate
			set IsDeleted=0
			where ID= @id
		end		
	end
	else begin
		delete from LoadingRate
		where ID= @id
	end
	
END
