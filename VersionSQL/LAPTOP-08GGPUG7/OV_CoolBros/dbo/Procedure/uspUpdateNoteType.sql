/****** Object:  Procedure [dbo].[uspUpdateNoteType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateNoteType] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@name varchar(100),
	@ReturnValue int output 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update NoteTypes
	set Name= @name,
	Code=@name
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

