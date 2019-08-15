/****** Object:  Procedure [dbo].[uspUpdateCompetencyType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateCompetencyType](@id int, @code varchar(50), @description varchar(500), @enabled char(1), @isSubCategoryExists int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @retVal int = -1;
    EXEC @retVal = uspCheckDoesCompetencyTypeExist @description, @code, @id
    
    DECLARE @oldDescription varchar(500) = '';
    SELECT @oldDescription = [Description] FROM CompetencyTypes WHERE Id = @id;
    IF @isSubCategoryExists = 1 BEGIN
		DELETE FROM CompetencyGroups WHERE Description = @oldDescription AND TypeId = @id
	END
	IF @isSubCategoryExists = 0 BEGIN
		IF NOT EXISTS (SELECT id FROM CompetencyGroups WHERE Description = @oldDescription AND TypeId = @id) BEGIN
			INSERT INTO CompetencyGroups(Code, [Description], [Enabled], SortOrder, TypeId)
				VALUES(@code, @description, @enabled, 1, @id);
		END
	END

    IF @retVal = 0 BEGIN
		UPDATE 
			CompetencyTypes
		SET	
			Code = @code,
			[Description] = @description,
			[Enabled] = @enabled,
			IsSubCategExists = @isSubCategoryExists
		WHERE
			Id = @id;
		IF @isSubCategoryExists = 0 BEGIN
			UPDATE 
				CompetencyGroups
			SET
				[Description] = @description,
				Code = @code,
				[Enabled] = @enabled
			WHERE
				TypeId = @id AND [Description] LIKE @oldDescription
		END
		RETURN 0;
	END
	ELSE IF @retVal = 1 BEGIN
		RETURN -1;
	END
	ELSE IF @retVal = 2 BEGIN
		RETURN -2;
	END
END

