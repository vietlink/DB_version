/****** Object:  Procedure [dbo].[uspGetPendingDataLoadByType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPendingDataLoadByType](@type int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT * FROM DataFileUpload WHERE IsProcessed = 0 AND [ProcessStartDate] IS NULL AND [Type] = @type
END


