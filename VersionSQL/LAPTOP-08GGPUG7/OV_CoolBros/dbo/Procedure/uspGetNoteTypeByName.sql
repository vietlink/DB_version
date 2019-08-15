/****** Object:  Procedure [dbo].[uspGetNoteTypeByName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetNoteTypeByName] 
	-- Add the parameters for the stored procedure here
	@filter varchar(100), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
		SELECT * from NoteTypes where Name=@filter and IsDeleted= @status
	
END

