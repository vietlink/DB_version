/****** Object:  Procedure [dbo].[uspBuildPositionGrouplessHierarchy]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspBuildPositionGrouplessHierarchy]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM PositionGrouplessHierarchy
	
	DECLARE 
		posCursor CURSOR FOR
	SELECT 
		id, parentid, isplaceholder
	FROM 
		Position
	WHERE
		IsDeleted = 0 AND IsUnassigned = 0

	DECLARE @posId int;
	DECLARE @parentId int;
	DECLARE @isPlaceholder bit;

	OPEN posCursor;

	FETCH NEXT FROM
		posCursor
	INTO
		@posId, @parentId, @isPlaceholder;

	WHILE @@FETCH_STATUS = 0  
	BEGIN
		IF @parentId IS NOT NULL BEGIN
			-- scan up the hierarchy looking for a parent which is not a group
	
			DECLARE @parent_Id int;
			DECLARE @parent_parentId int
			DECLARE @parent_isPlaceholder int;

			SET @parent_parentId = @parentId;

			INSERT INTO PositionGrouplessHierarchy(PositionID, ParentID)
				VALUES(@posId, @parent_parentId);

			SELECT 
				@parent_Id = id, @parent_parentId = parentid, @parent_isPlaceholder = isplaceholder
			FROM
				Position
			WHERE
				id = @parent_parentId;

			-- Scan up the hierarchy creating dummy data, stop at position
			WHILE @parent_parentId IS NOT NULL
			BEGIN
				IF @parent_isPlaceholder = 0
					BREAK;

				IF @parent_parentId IS NOT NULL
					INSERT INTO PositionGrouplessHierarchy(PositionID, ParentID)
						VALUES(@posId, @parent_parentId);

				SELECT 
					@parent_Id = id, @parent_parentId = parentid, @parent_isPlaceholder = isplaceholder
				FROM
					Position
				WHERE
					id = @parent_parentId;
			END

		END
		FETCH NEXT FROM
			posCursor
		INTO
			@posId, @parentId, @isPlaceholder;
	END

	CLOSE posCursor;
	DEALLOCATE posCursor;
END


