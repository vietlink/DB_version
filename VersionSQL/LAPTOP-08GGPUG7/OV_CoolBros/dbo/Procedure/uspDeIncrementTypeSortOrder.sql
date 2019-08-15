/****** Object:  Procedure [dbo].[uspDeIncrementTypeSortOrder]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeIncrementTypeSortOrder](@typeid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Inrement = reduce from sort order
    DECLARE @currentSortOrder int = 0;
    SELECT @currentSortOrder = SortOrder FROM CompetencyTypes WHERE Id = @typeid;
    
    IF @currentSortOrder > 0 BEGIN
		DECLARE @previousMinSort int = 0;
		DECLARE @previousId int = 0;
		DECLARE @maxSort int = 0;
		SELECT @maxSort = MAX(SortOrder) + 1 FROM CompetencyTypes;
		
		SELECT 
			@previousMinSort = MIN(SortOrder)
		FROM 
			CompetencyTypes
		WHERE 
			SortOrder > @currentSortOrder
							
		IF @previousMinSort < @maxSort BEGIN
			-- the one above
			UPDATE t SET t.SortOrder = @currentSortOrder FROM CompetencyTypes t WHERE t.SortOrder = @previousMinSort;
			-- the one being changed
			UPDATE t SET t.SortOrder = @previousMinSort FROM CompetencyTypes t WHERE t.Id = @typeid;
		END
	END

END

