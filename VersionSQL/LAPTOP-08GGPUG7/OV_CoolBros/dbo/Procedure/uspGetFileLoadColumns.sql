/****** Object:  Procedure [dbo].[uspGetFileLoadColumns]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFileLoadColumns](@tableName varchar(max), @isAddMode bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @entityId int = 0;
    SELECT  @entityId = id FROM Entity WHERE tablename = @tableName;
	DECLARE @sourceId int = 0;
	DECLARE @addModeId int = 0;
	SELECT @sourceId = id FROM AttributeSource WHERE code = 'fileload';
	SELECT @addModeId = id FROM AttributeSource WHERE code = 'dataentry';
	SELECT * FROM Attribute WHERE entityid = @entityId AND (AttributeSourceID = @sourceId OR (@isAddMode = 1 AND AttributeSourceID = @addModeId))
END

