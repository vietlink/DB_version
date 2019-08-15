/****** Object:  Procedure [dbo].[uspAddCompetencyType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddCompetencyType](@code varchar(50), @description varchar(500), @enabled char(1), @isSubCategoryExists int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @retVal int = -1;
	
	EXEC @retVal = uspCheckDoesCompetencyTypeExist @description, @code, 0
	
	IF @retVal = 0 BEGIN
		DECLARE @maxSort int = 1;
		SELECT @maxSort = MAX(SortOrder) + 1 FROM CompetencyTypes;
		IF @maxSort IS NULL
			SET @maxSort = 1;
		INSERT INTO CompetencyTypes(Code, [Description], [Enabled], IsSubCategExists, SortOrder)
			VALUES (@code, @description, @enabled, @isSubCategoryExists, @maxSort);
		
		-- Create a matching group if it does not exist
		IF @isSubCategoryExists = 0 BEGIN
			INSERT INTO CompetencyGroups(Code, [Description], [Enabled], SortOrder, TypeId)
				VALUES(@code, @description, @enabled, 1, @@IDENTITY);
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

