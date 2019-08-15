/****** Object:  Procedure [dbo].[uspGetWorkHoursByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspGetWorkHoursByID] 
	-- Add the parameters for the stored procedure here
	@id int, @filter varchar(300)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@id=0) begin
		select * from DefaultWorkHours wh
		where wh.Day like '%'+@filter+'%' 
	end
	else begin
		SELECT * from DefaultWorkHours where ID=@id
	end
END

