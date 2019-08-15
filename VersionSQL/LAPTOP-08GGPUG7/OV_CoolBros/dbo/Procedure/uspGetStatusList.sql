/****** Object:  Procedure [dbo].[uspGetStatusList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetStatusList](@isAddList bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM [Status] WHERE @isAddList = 0 OR (@isAddList = 1 AND [IsAddStatus] = 1)
END

