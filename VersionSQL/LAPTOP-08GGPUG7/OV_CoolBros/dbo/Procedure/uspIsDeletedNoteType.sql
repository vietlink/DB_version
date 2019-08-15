/****** Object:  Procedure [dbo].[uspIsDeletedNoteType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspIsDeletedNoteType] 
	-- Add the parameters for the stored procedure here
	@value varchar(100) , 
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @ReturnValue= (select IsDeleted
	from NoteTypes
	where Name= @value)
END

