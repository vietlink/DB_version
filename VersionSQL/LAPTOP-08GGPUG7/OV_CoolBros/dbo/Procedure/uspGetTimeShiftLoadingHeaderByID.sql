/****** Object:  Procedure [dbo].[uspGetTimeShiftLoadingHeaderByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimeShiftLoadingHeaderByID] 
	-- Add the parameters for the stored procedure here
	@id int, @filter varchar(100), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@id=0) begin
		select * from TimeShiftLoadingHeader
		where Description like '%'+@filter+'%' and IsDeleted=@status and IsCustom=0
	end
	else begin
		SELECT * from TimeShiftLoadingHeader where ID=@id and IsDeleted= @status
	end
END

