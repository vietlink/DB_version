/****** Object:  Procedure [dbo].[uspGetCurrentSystemDocumentSize]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCurrentSystemDocumentSize]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT
		ISNULL(SUM(CAST(d.Size as int)), 0) as Size
	FROM
		Documents d
	WHERE
		d.IsDeleted = 0;
END


