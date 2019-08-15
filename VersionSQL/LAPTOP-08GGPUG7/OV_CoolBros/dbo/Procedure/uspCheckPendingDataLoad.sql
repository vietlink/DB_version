/****** Object:  Procedure [dbo].[uspCheckPendingDataLoad]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckPendingDataLoad]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT ISNULL(COUNT(*), 0) as Count FROM DataFileUpload WHERE IsProcessed = 0 AND [ProcessStartDate] IS NULL    
END


