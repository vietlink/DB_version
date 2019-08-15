/****** Object:  Procedure [dbo].[uspDeIncrementGroupSortOrder]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeIncrementGroupSortOrder](@groupid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Inrement = reduce from sort order
    DECLARE @currentSortOrder int = 0;
    DECLARE @typeId int = 0;
    
    SELECT @currentSortOrder = SortOrder, @typeId = TypeId FROM CompetencyGroups WHERE Id = @groupid;
    
    IF @currentSortOrder > 0 BEGIN
		DECLARE @previousMinSort int = 0;
		DECLARE @previousId int = 0;
		DECLARE @maxSort int = 0;
		SELECT @maxSort = MAX(SortOrder) + 1 FROM CompetencyGroups WHERE TypeId = @typeId;
		
		SELECT 
			@previousMinSort = MIN(SortOrder)
		FROM 
			CompetencyGroups
		WHERE 
			TypeId = @typeid AND SortOrder > @currentSortOrder AND SortOrder > 0
							
		IF @previousMinSort < @maxSort BEGIN
			-- the one above
			UPDATE g SET g.SortOrder = @currentSortOrder FROM CompetencyGroups g WHERE g.TypeId = @typeId AND g.SortOrder = @previousMinSort;
			-- the one being changed
			UPDATE g SET g.SortOrder = @previousMinSort FROM CompetencyGroups g WHERE g.Id = @groupid;
		END
	END

END

