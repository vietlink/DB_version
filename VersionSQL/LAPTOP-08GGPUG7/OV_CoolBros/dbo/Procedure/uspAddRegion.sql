/****** Object:  Procedure [dbo].[uspAddRegion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddRegion] 
	-- Add the parameters for the stored procedure here
	@description varchar(100),  @default bit, @status bit, @code varchar(10), @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@status=0) begin
		update HolidayRegion	
		set 
		IsDefault=@default		
		where Code=@code
		set @ReturnValue= 1
	end
	else begin
	if (@default=1) begin
		update HolidayRegion
		set IsDefault= 0
	end		
	insert into HolidayRegion(Description, IsDefault, Code)
	values
	(@description, 		
	@default,
	@code
	)
	set @ReturnValue= @@IDENTITY
	end
END
