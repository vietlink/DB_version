/****** Object:  Procedure [dbo].[uspCountGeneralNoteType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspCountGeneralNoteType] 
	-- Add the parameters for the stored procedure here	
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	set @ReturnValue= (SELECT count (n.id) as number
	from NoteTypes n
	where n.Type='general')

END

