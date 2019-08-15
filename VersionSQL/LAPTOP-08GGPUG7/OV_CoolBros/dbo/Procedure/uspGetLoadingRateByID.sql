/****** Object:  Procedure [dbo].[uspGetLoadingRateByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLoadingRateByID] 
	-- Add the parameters for the stored procedure here
	@id int, @filter varchar(300), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@id=0) begin
		select * from LoadingRate
		where Description like '%'+@filter+'%' and IsDeleted=@status ORDER BY value;
	end
	else begin
		SELECT * from LoadingRate where ID=@id and IsDeleted= @status ORDER BY value;
	end
END
