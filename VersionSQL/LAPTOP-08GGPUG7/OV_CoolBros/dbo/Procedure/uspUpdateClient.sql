/****** Object:  Procedure [dbo].[uspUpdateClient]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateClient] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@code varchar(10),
	@description varchar(100),
	@ReturnValue int output 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	

	update Clients
	set Code= @code,
	Description=@description
	where ID=@id
-- update related table needed
	
	IF @@error != 0
	BEGIN
		SET @ReturnValue =0
	
	END
	
	ELSE
	BEGIN
	
		SET @ReturnValue =@id 
	END
END

