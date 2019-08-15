/****** Object:  Procedure [dbo].[GetUnprocessedDataFileUploads]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetUnprocessedDataFileUploads]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [dbo].[DataFileUpload] WHERE IsProcessed = 0
	ORDER BY DATEADD(dd, 0, DATEDIFF(dd, 0, CreatedDate)) DESC, [Type] ASC
END


