/****** Object:  Procedure [dbo].[uspGetCurrentFileUpload]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCurrentFileUpload]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 * FROM DataFileUpload WHERE IsProcessed = 0 AND ProcessStartDate IS NOT NULL ORDER BY DATEADD(dd, 0, DATEDIFF(dd, 0, CreatedDate)) DESC, [Type] ASC
END


