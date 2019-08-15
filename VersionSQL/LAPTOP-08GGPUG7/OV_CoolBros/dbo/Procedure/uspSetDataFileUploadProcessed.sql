/****** Object:  Procedure [dbo].[uspSetDataFileUploadProcessed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetDataFileUploadProcessed](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE DataFileUpload SET IsProcessed = 1, ProcessedDate = GETDATE() WHERE Id = @id;
END


