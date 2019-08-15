/****** Object:  Procedure [dbo].[uspUpdateRegion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateRegion] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@description varchar(50), @default bit, @code varchar(10), @ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
	if (@default=1) begin
		update HolidayRegion 
		set IsDefault= 0
		where id <> @id
	end
	update HolidayRegion
	set Description=@description,		
	Code=@code,
	IsDefault=@default
	where ID=@id
	
	IF @@error != 0
	BEGIN
		SET @ReturnValue =0
	
	END
	
	ELSE
	BEGIN
	
		SET @ReturnValue =@id 
	END
END
