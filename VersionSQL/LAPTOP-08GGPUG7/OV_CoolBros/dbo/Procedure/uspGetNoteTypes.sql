/****** Object:  Procedure [dbo].[uspGetNoteTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetNoteTypes](@filter varchar(50))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @filter = '' BEGIN
    SELECT * FROM NoteTypes;
	END
	ELSE BEGIN
	SELECT * FROM NoteTypes WHERE [type] = @filter;
	END
END

