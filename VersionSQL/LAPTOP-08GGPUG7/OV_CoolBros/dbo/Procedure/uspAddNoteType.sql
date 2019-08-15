/****** Object:  Procedure [dbo].[uspAddNoteType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddNoteType] 
	-- Add the parameters for the stored procedure here
	@name varchar(100), @status bit, @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@status=0) begin
		update NoteTypes
		set 		
		Code= @name,		
		IsDeleted=@status
		where Name=@name
		set @ReturnValue=1;
	end
	else begin
		insert into NoteTypes (Name, Code, Type)
		values
		(@name, 
		@name,
		'general')
		set @ReturnValue= @@IDENTITY
	end
END

