/****** Object:  Procedure [dbo].[uspAddLoadingRate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddLoadingRate] 
	-- Add the parameters for the stored procedure here
	 @code varchar(5), @description varchar(100), @value decimal (5,2), @default bit, @status bit, @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@status=0) begin
		update LoadingRate
		set 				
		Description=@description,
		IsDefault=@default,
		IsDeleted=@status
		where Code= @code
		set @ReturnValue=1;
	end
	else begin
		if (@default=1) 
			update LoadingRate set IsDefault=0
		else begin
			insert into LoadingRate(Code, Description, Value, isDefault, IsDeleted)
		values
		(@code, 
		@description,
		@value,
		@default,
		0)
		end		
		set @ReturnValue= @@IDENTITY
	end
END

