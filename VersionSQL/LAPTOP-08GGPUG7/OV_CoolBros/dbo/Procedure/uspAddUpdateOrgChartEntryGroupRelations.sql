/****** Object:  Procedure [dbo].[uspAddUpdateOrgChartEntryGroupRelations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateOrgChartEntryGroupRelations](@groupId int, @idList varchar(max), @mandatoryList varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idTable TABLE(id int);
--	SET @outputTable = fnSplitString(@idList, ',');

	IF CHARINDEX(',', @idList, 0) > 0 BEGIN
		INSERT INTO @idTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@idList, ',');
    END
    ELSE IF LEN(@idList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idTable(id) VALUES(CAST(@idList AS int));
    END

	DECLARE @mandatoryTable TABLE(id int);
	IF CHARINDEX(',', @mandatoryList, 0) > 0 BEGIN
		INSERT INTO @mandatoryTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@mandatoryList, ',');
    END
    ELSE IF LEN(@mandatoryList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @mandatoryTable(id) VALUES(CAST(@mandatoryList AS int));
    END

	DELETE FROM
		OrgChartEntryGroupRelations
	WHERE
		OrgChartEntryGroupID = @groupId
	AND
		AttributeID NOT IN (SELECT id FROM @idTable);

	DECLARE splitScan CURSOR FOR
		SELECT id FROM @idTable
	OPEN splitScan;
	DECLARE @splitData varchar(15);
	FETCH NEXT FROM splitScan INTO @splitData;
	WHILE @@FETCH_STATUS = 0 BEGIN
		DECLARE @insertId int = CAST(@splitData as int);
		IF NOT EXISTS (SELECT attributeid FROM OrgChartEntryGroupRelations WHERE OrgChartEntryGroupID = @groupId AND AttributeID = @insertId) BEGIN
			INSERT INTO
				OrgChartEntryGroupRelations(OrgChartEntryGroupID, AttributeID, IsMandatory, SortOrder)
					VALUES(@groupId, @insertId,
					CASE WHEN EXISTS (SELECT id FROM @mandatoryTable WHERE id = @insertId) THEN 1 ELSE 0 END,
					ISNULL((SELECT MAX(SortOrder) + 1 FROM OrgChartEntryGroupRelations WHERE OrgChartEntryGroupID = @groupId), 1))
		END
		ELSE BEGIN
			UPDATE OrgChartEntryGroupRelations
				SET IsMandatory = CASE WHEN EXISTS (SELECT id FROM @mandatoryTable WHERE id = @insertId) THEN 1 ELSE 0 END
			WHERE
				OrgChartEntryGroupID = @groupId AND AttributeID = @insertId
		END
		FETCH NEXT FROM splitScan INTO @splitData;
	END

	CLOSE splitScan;
	DEALLOCATE splitScan;
END


