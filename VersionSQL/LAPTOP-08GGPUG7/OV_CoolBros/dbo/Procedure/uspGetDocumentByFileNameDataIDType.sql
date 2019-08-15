/****** Object:  Procedure [dbo].[uspGetDocumentByFileNameDataIDType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDocumentByFileNameDataIDType](@fileName varchar(260), @dataId int, @pageType varchar(20))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT TOP 1 * FROM Documents WHERE (DataID = @dataId AND [FileName] LIKE @fileName AND PageType LIKE @pageType) AND IsDeleted = 0
	ORDER BY CreatedDate DESC
END


