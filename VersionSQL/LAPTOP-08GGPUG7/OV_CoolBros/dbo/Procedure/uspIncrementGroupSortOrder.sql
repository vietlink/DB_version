/****** Object:  Procedure [dbo].[uspIncrementGroupSortOrder]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspIncrementGroupSortOrder](@groupid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Inrement = reduce from sort order
    DECLARE @currentSortOrder int = 0;
    DECLARE @typeid int = 0;
    
    SELECT @currentSortOrder = SortOrder, @typeid = TypeId FROM CompetencyGroups WHERE Id = @groupid;
    
    IF @currentSortOrder > 0 BEGIN
		DECLARE @previousMaxSort int = 0;
		DECLARE @previousId int = 0;
		
		SELECT 
			@previousMaxSort = MAX(SortOrder)
		FROM 
			CompetencyGroups
		WHERE 
			TypeId = @typeid AND SortOrder < @currentSortOrder AND SortOrder > 0
							
		IF @previousMaxSort > 0 BEGIN
			-- the one above
			UPDATE g SET g.SortOrder = @currentSortOrder FROM CompetencyGroups g WHERE g.SortOrder = @previousMaxSort AND TypeId = @typeid;
			-- the one being changed
			UPDATE g SET g.SortOrder = @previousMaxSort FROM CompetencyGroups g WHERE g.Id = @groupid;
		END
	END

END

