/****** Object:  Procedure [dbo].[uspGetUsedPositionAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetUsedPositionAttributes]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @notUsedId int;
	DECLARE @positionEntity int

	SELECT @notUsedId = id FROM AttributeSource WHERE code = 'notused';
	SELECT @positionEntity = id FROM Entity WHERE tablename = 'Position';
    SELECT * FROM Attribute WHERE entityid = @positionEntity AND (AttributeSourceID <> @notUsedId OR AttributeSourceID IS NULL)
	ORDER BY sortorder
END


